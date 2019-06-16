open Mpst_simple
let a = {label={make_obj=(fun v->object method role_A=v end);
                call_obj=(fun o->o#role_A)};
         lens=Succ Zero}
let b = {label={make_obj=(fun v->object method role_B=v end);
                call_obj=(fun o->o#role_B)};
         lens=Succ (Succ Zero)}
let c = {label={make_obj=(fun v->object method role_C=v end);
                call_obj=(fun o->o#role_C)};
         lens=Zero}
let d = {label={make_obj=(fun v->object method role_D=v end);
                call_obj=(fun o->o#role_D)};
         lens=Succ (Succ (Succ Zero))}

let left_middle_or_right =
  {obj_merge=(fun l r -> object method left=l#left method middle=l#middle method right=r#right end);
   obj_splitL=(fun lr -> (lr :> <left : _; middle: _>));
   obj_splitR=(fun lr -> (lr :> <right : _>));
  }

let left_or_middle =
  {obj_merge=(fun l r -> object method left=l#left method middle=r#middle end);
   obj_splitL=(fun lr -> (lr :> <left : _>));
   obj_splitR=(fun lr -> (lr :> <middle : _>));
  }

let left_or_middle_right =
  {obj_merge=(fun l r -> object method left=l#left method middle=r#middle method right=r#right end);
   obj_splitL=(fun lr -> (lr :> <left : _>));
   obj_splitR=(fun lr -> (lr :> <middle: _; right : _>));
  }

let middle_or_right =
  {obj_merge=(fun l r -> object method middle=l#middle method right=r#right end);
   obj_splitL=(fun lr -> (lr :> <middle : _>));
   obj_splitR=(fun lr -> (lr :> <right : _>));
  }

let loop1 () =
  fix (fun t ->
        choice_at a (to_b left_middle_or_right)
          (a, choice_at a (to_b left_or_middle)
              (a, (a --> b) left @@ t)
              (a, (a --> b) middle @@ t))
          (a, (a --> b) right @@ (a --> c) msg @@ finish))


let tA ea finally =
  let rec loop () =
    let ea = send (ea#role_B#left) () in
    let ea = send (ea#role_B#middle) () in
    let ea = send (ea#role_B#left) () in
    let ea = send (ea#role_B#right) () in
    let ea = send (ea#role_C#msg) () in
    finally ea
  in
  loop ()

let tB eb finally =
  let rec loop eb =
    match Event.sync (eb#role_A) with
    | `left(_,eb) -> print_endline"left"; loop eb
    | `middle(_,eb) -> print_endline"middle"; loop eb
    | `right(_,eb) -> print_endline"right"; finally eb
  in
  loop eb
  
let () =
  let () = print_endline "loop1" in
  let g = loop1 () in
  let () = print_endline "global combinator generated" in
  let ea = get_ep a g in
  print_endline "epp a done";
  let eb = get_ep b g in
  print_endline "epp b done";
  let ec = get_ep c g in
  print_endline "epp c done";
  ignore (Thread.create (fun () ->
              tA ea (fun ea -> close ea)
            ) ());
  ignore (Thread.create (fun () ->
              tB eb (fun eb -> close eb)
            ) ());
  begin
    match receive (ec#role_A) with
    | `msg(_,ec) -> close ec
  end;
  print_endline "loop1 done"

let loop2 () =
  fix (fun t ->
        choice_at a (to_b left_or_middle_right)
          (a, (a --> b) left @@ t)
          (a, choice_at a (to_b middle_or_right)
              (a, (a --> b) middle @@ t)
              (a, (a --> b) right @@ (a --> c) msg @@ t)))

let () =
  let () = print_endline "loop2" in
  let g = loop2 () in
  print_endline "loop2 global done";
  let ea = get_ep a g in
  print_endline "epp a done";
  let eb = get_ep b g in
  print_endline "epp b done";
  let ec = get_ep c g in
  print_endline "epp c done";
  ignore (Thread.create (fun () ->
              let rec loop ea =
                tA ea (fun ea -> loop ea)
              in
              loop ea
            ) ());
  ignore (Thread.create (fun () ->
              let rec loop eb =
                tB eb (fun eb -> loop eb)
              in
              loop eb
            ) ());
  begin
    let rec loop cnt ec =
      if cnt > 0 then begin
          match receive (ec#role_A) with
          | `msg(_,ec) -> loop (cnt-1) ec
        end
      else
        print_endline "interrupt"
    in
    ignore (loop 5 ec)
  end;
  print_endline "loop2 done"