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

(*
let print_stdin = In_channel.input_all In_channel.stdin |> Printf.printf "%s"
*)

(* This works and now splits the input into two seperate list, one for config and one for tags *)
let rec read_config x y =
  match In_channel.input_line In_channel.stdin with
  | Some "" -> read_config y x
  | Some line -> read_config (line :: x) y
  | None -> (List.rev y, List.rev x)


let rec nth_element list n =
  match list with
  | [] -> failwith "Index out of bounds" (* Handle empty list *)
  | x :: xs -> if n = 0 then x else nth_element xs (n - 1)


let () = let s = read_config [] [] in
let n = nth_element (fst s) (List.length (fst s) -1) in
  Printf.printf "%s" n

(* in Printf.printf "First: %d\n" (List.length (fst s));
Printf.printf "Second: %d\n" (List.length (snd s));
List.iter (Printf.printf "%s") (snd s) *)



