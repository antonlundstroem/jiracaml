open Yojson.Basic.Util

module StringMap = Map.Make(String)

(*
{"start":"20160405T162205Z",\
"end":"20160405T162211Z",\
"tags":["This is a multi-word tag","ProjectA","tag123"]
},

type conf = {
  opt : string;

}
  *)

type entry = {
  start_ : string;
  end_ : string;
  tags_ : string list;
}

let entry_of_json json =
  {
    start_ = json |> member "start" |> to_string;
    end_ = json |> member "end" |> to_string;
    tags_ = json |> member "tags" |> to_list |> List.map to_string;
  }

(* Split incoming stind into two lists, one for config and one for tags *)
let rec read_config x y =
  match In_channel.input_line In_channel.stdin with
  | Some "" -> read_config y x
  | Some line -> 
      if line = "[" || line = "]" then
        read_config x y
      else
        read_config (line :: x) y
  | None -> (List.rev y, List.rev x)


let rec nth_element list n =
  match list with
  | [] -> failwith "Index out of bounds" (* Handle empty list *)
  | x :: xs -> if n = 0 then x else nth_element xs (n - 1)


let clean s =
  let len = String.length s in
  if len > 0 && String.get s (len - 1) = ',' then
    String.sub s 0 (len - 1)
  else
    s

let () = let stdin = read_config [] [] in
  let tags = (snd stdin) in
  let entries = List.map (fun entry ->
    (* Clean trailing comma *)
    let s = clean entry in
    let json = Yojson.Basic.from_string s in 
    entry_of_json json
  ) tags
  in 
  List.iter (fun entry ->
    Printf.printf "%s " entry.start_;
    Printf.printf "%s " entry.end_;
    Printf.printf "%s " (String.concat "," entry.tags_);
    print_newline()
  ) entries

(*
let () =
  let entries = List.map (fun entry ->
    (* Clean trailing comma *)
    let s = clean entry in
    Printf.printf "%s" s;
    let json = Yojson.Basic.from_string s in 
    entry_of_json json
  ) json_strings
  in 
  List.iter (fun entry ->
    Printf.printf "%s " entry.start_;
    Printf.printf "%s " entry.end_;
    Printf.printf "%s " (String.concat "," entry.tags_);
  ) entries
*)


(*
let () = let stdin = read_config [] [] in
let config = (fst stdin) 
let tags = (snd stdin) in
let nc = nth_element (config) (1) in
let nt = nth_element (tags) (1) in
Printf.printf "%s" nc;
Printf.printf "%s" nt;
*)
