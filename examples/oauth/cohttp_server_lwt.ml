(* copied from https://github.com/mirage/ocaml-cohttp/blob/d60168a79765624d2e0c7fd801084e00eb24ef98/cohttp-lwt-unix/bin/cohttp_server_lwt.ml *)

(*{{{ Copyright (c) 2014 Romain Calascibetta <romain.calascibetta@gmail.com>
 * Copyright (c) 2014 Anil Madhavapeddy <anil@recoil.org>
 * Copyright (c) 2014 David Sheets <sheets@alum.mit.edu>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
  }}}*)

open Lwt.Infix
open Cohttp_lwt_unix

open Cohttp_server

let method_filter meth (res,body) = match meth with
  | `HEAD -> Lwt.return (res,`Empty)
  | _ -> Lwt.return (res,body)

let serve_file ~docroot ~uri =
  let fname = Server.resolve_local_file ~docroot ~uri in
  Server.respond_file ~fname ()

let ls_dir dir =
  Lwt_stream.to_list
    (Lwt_stream.filter ((<>) ".")
       (Lwt_unix.files_of_directory dir))

let serve ~info ~docroot ~index uri path =
  let file_name = Server.resolve_local_file ~docroot ~uri in
  Lwt.catch (fun () ->
    Lwt_unix.stat file_name
    >>= fun stat ->
    match kind_of_unix_kind stat.Unix.st_kind with
    | `Directory -> begin
      let path_len = String.length path in
      if path_len <> 0 && path.[path_len - 1] <> '/'
      then Server.respond_redirect ~uri:(Uri.with_path uri (path^"/")) ()
      else match Sys.file_exists (file_name / index) with
      | true -> let uri = Uri.with_path uri (path / index) in
                serve_file ~docroot ~uri
      | false ->
        ls_dir file_name
        >>= Lwt_list.map_s (fun f ->
          let file_name = file_name / f in
          Lwt.try_bind
            (fun () -> Lwt_unix.LargeFile.stat file_name)
            (fun stat ->
               Lwt.return (Some (kind_of_unix_kind stat.Unix.LargeFile.st_kind),
                      stat.Unix.LargeFile.st_size,
                      f))
            (fun _exn -> Lwt.return (None, 0L, f)))
        >>= fun listing ->
        let body = html_of_listing uri path (sort listing) info in
        Server.respond_string ~status:`OK ~body ()
    end
    | `File -> serve_file ~docroot ~uri
    | _ ->
      Server.respond_string ~status:`Forbidden
        ~body:(html_of_forbidden_unnormal path info)
        ()
  ) (function
  | Unix.Unix_error(Unix.ENOENT, "stat", p) as e ->
    if p = file_name
    then Server.respond_string ~status:`Not_found
      ~body:(html_of_not_found path info)
      ()
    else Lwt.fail e
  | e -> Lwt.fail e
  )

type cohttp_server_hook = Request.t -> Cohttp_lwt.Body.t -> (Response.t * Cohttp_lwt.Body.t) option Lwt.t

let hook : cohttp_server_hook ref = ref (fun _req _body -> Lwt.return None)

let handler ~info ~docroot ~index (ch,_conn) req body =
  let uri = Cohttp.Request.uri req in
  let path = Uri.path uri in
  (* Log the request to the console *)
  Lwt_log.debug_f "%s %s %s"
    (Cohttp.(Code.string_of_method (Request.meth req)))
    path
    (Sexplib.Sexp.to_string_hum (Conduit_lwt_unix.sexp_of_flow ch)) >>= fun () ->
  (* Get a canonical filename from the URL and docroot *)
  !hook req body >>= fun res ->
  match res with
  | Some res -> Lwt.return res
  | None ->
  match Request.meth req with
  | (`GET | `HEAD) as meth ->
    serve ~info ~docroot ~index uri path
    >>= method_filter meth
  | meth ->
    let meth = Cohttp.Code.string_of_method meth in
    let allowed = ["GET"; "HEAD"] in
    let headers = Cohttp.Header.(add_multi (init ()) "allow" allowed) in
    Server.respond_string ~headers ~status:`Method_not_allowed
      ~body:(html_of_method_not_allowed meth (String.concat "," allowed) path info) ()

let start_server docroot port host index tls () =
  Lwt_log.info_f "Listening for HTTP request on: %s %d" host port >>= fun () ->
  let info = Printf.sprintf "Served by Cohttp/Lwt listening on %s:%d" host port in
  let conn_closed (ch,_conn) =
    Lwt_log.ign_debug_f "connection %s closed"
      (Sexplib.Sexp.to_string_hum (Conduit_lwt_unix.sexp_of_flow ch)) in
  let callback = handler ~info ~docroot ~index in
  let config = Server.make ~callback ~conn_closed () in
  let mode = match tls with
    | Some (c, k) -> `TLS (`Crt_file_path c, `Key_file_path k, `No_password, `Port port)
    | None -> `TCP (`Port port)
  in
  Conduit_lwt_unix.init ~src:host ()
  >>= fun ctx ->
  let ctx = Cohttp_lwt_unix.Net.init ~ctx () in
  Server.create ~ctx ~mode config

let lwt_start_server docroot port host index verbose tls =
  (match List.length verbose with
  | 0 -> ()
  | 1 -> Lwt_log_core.(add_rule "*" Info)
  | _ -> Lwt_log_core.(add_rule "*" Debug));
  Lwt_main.run (start_server docroot port host index tls ())

open Cmdliner

let host =
  let doc = "IP address to listen on." in
  Arg.(value & opt string "::" & info ["s"] ~docv:"HOST" ~doc)

let port =
  let doc = "TCP port to listen on." in
  Arg.(value & opt int 8080 & info ["p"] ~docv:"PORT" ~doc)

let index =
  let doc = "Name of index file in directory." in
  Arg.(value & opt string "index.html" & info ["i"] ~docv:"INDEX" ~doc)

let verb =
  let doc = "Logging output to console." in
  Arg.(value & flag_all & info ["v"; "verbose"] ~doc)

let tls =
  let doc = "TLS certificate files." in
  Arg.(value & opt (some (pair string string)) None & info ["tls"] ~docv:"CERT,KEY" ~doc)

let doc_root =
  let doc = "Serving directory." in
  Arg.(value & pos 0 dir "." & info [] ~docv:"DOCROOT" ~doc)

let cmd =
  let doc = "a simple http server" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) sets up a simple http server with lwt as backend";
    `S "BUGS";
    `P "Report them via e-mail to <mirageos-devel@lists.xenproject.org>, or \
        on the issue tracker at <https://github.com/mirage/ocaml-cohttp/issues>";
  ] in
  Term.(pure lwt_start_server $ doc_root $ port $ host $ index $ verb $ tls),
  Term.info "cohttp-server" ~version:Cohttp.Conf.version ~doc ~man
