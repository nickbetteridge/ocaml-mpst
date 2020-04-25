include (Shared_lin : S.GLOBAL_COMBINATORS_LIN)

exception InvalidEndpoint = Mpst.InvalidEndpoint
exception UnguardedLoop = Mpst.UnguardedLoop
exception UnguardedLoopSeq = Mpst.UnguardedLoopSeq

module S = S
module Combinators = Combinators_lin
module Shared = Shared_lin
module Util = Mpst.Util
