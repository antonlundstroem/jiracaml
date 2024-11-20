(* open Yojson.Basic.Util;; *)

module StringMap = Map.Make(String)

(*
{"start":"20160405T162205Z",\
"end":"20160405T162211Z",\
"tags":["This is a multi-word tag","ProjectA","tag123"]
},

type conf = {
  opt : string;

}

type entry = {
  start_t : string;
  end_t : string;
  tags : string list;
}

*)
(* Tuple with HashMap of configs and a List with the logs *)

let read_stdin =
  let chan = stdin in
  let rec loop x =
    match input_line chan with
        | line ->
            (* Printf.printf "This is a line: %s" line; *)
            loop ((line ^ "\n") :: x)
        | exception End_of_file -> List.rev x
  in
    loop []

let read_stdin_two = In_channel.input_all In_channel.stdin

let parse_config string_of_config (*: (string list * string StringMap.t) *) =
  (* let entries : entry list = [] in *)
  let rec loop acc config entries =
    match config with
    | [] -> (acc, entries)
    | hd :: tl -> loop (hd :: acc) tl (StringMap.add "foo" "bar" entries)
    in
      loop [] string_of_config StringMap.empty


let print_std = let inp = read_stdin in
  List.iter (Printf.printf "%s") inp


let () = let inp = read_stdin_two in
  (* let cfg = parse_config inp in *)
let first = String.split_on_char '\n' inp in
  List.iter (Printf.printf "%s") first

