open Core

let range i j =
  let rec range' i j acc =
    if i > j then acc
    else range' i (j - 1) (j :: acc) in
  range' i (j - 1) []

let reserved_symbols =
  let reserved_register_symbols =
    List.map (range 0 16)
      ~f:(fun n -> ((Printf.sprintf "R%d" n), n)) in
  [("SP",   0x0000);
   ("LCL",  0x0001);
   ("ARG",  0x0002);
   ("THIS", 0x0003);
   ("THAT", 0x0004)]
  @ reserved_register_symbols (* R0-R15 *)
  @ [("SCREEN", 0x4000);
     ("KBD",    0x6000)]

let create_symbol_table file_name =
  let table =
    List.fold reserved_symbols
      ~init:(Symbol_table.create ())
      ~f:(fun table (symbol_name, address) ->
          Symbol_table.add ~equal:(=) table symbol_name (Address.Address address)) in
  let parser = Parser.create file_name in
  let rec assemble' table address =
    let command = Parser.next_command parser in
    match command with
    | Some command -> begin
        match command with
        | Hack_command.A_OP a_op -> begin
            match a_op with
            | Address_operation.Symbol symbol_name -> begin
                assemble'
                  (if Symbol_table.exists ~equal:(=) table symbol_name
                   then table
                   else (Symbol_table.add ~equal:(=) table symbol_name Address.Undefined))
                  (address + 1)
              end
            | Address_operation.Number _ -> assemble' table (address + 1)
          end
        | Hack_command.Label symbol_name -> begin
            if Symbol_table.defined_symbol_exists table symbol_name
            then failwith (sprintf "Duplicate symbol: %s" symbol_name)
            else
              assemble'
                (Symbol_table.add ~equal:(=) table symbol_name (Address.Address address))
                address
          end
        | _ -> assemble' table (address + 1)
      end
    | None -> table in
  assemble' table 0

let assemble_with_symbol symbol_table file_name =
  let parser = Parser.create file_name in
  let output_file_name = (Filename.chop_extension file_name) ^ ".hack" in
  Out_channel.with_file output_file_name ~f:(fun oc ->
      let rec assemble' () =
        let command = Parser.next_command parser in
        match command with
        | Some (Hack_command.Label _) -> assemble' ()
        | Some command' -> begin
            Out_channel.output_string oc
	      (Hack_command.code_to_string (Hack_command.to_code command' symbol_table));
	    Out_channel.output_string oc "\n";
            assemble' ()
          end
        | None -> () in
      assemble' ()
    )

let print_symbol_table table =
  print_endline "=== Symbol table ===";
  List.iter (List.rev (Symbol_table.to_list table)) ~f:(fun (name, address) ->
      printf "%10s %s\n" name (Address.to_string address))

let var_start_address = 0x0010

let update_var_address symbol_table =
  let symbols = List.rev (Symbol_table.to_list symbol_table) in
  let (table, _) =
    List.fold symbols
      ~init:(Symbol_table.create (), var_start_address)
      ~f:(fun (table, address_num) (symbol_name, address) ->
          match address with
          | Address.Address _ -> (Symbol_table.add ~equal:(=) table symbol_name address, address_num)
          | Address.Undefined ->
            (Symbol_table.add ~equal:(=) table
               symbol_name (Address.Address address_num), address_num + 1)) in
  table

let assemble file_name =
  let symbol_table = create_symbol_table file_name in
  let symbol_table' = update_var_address symbol_table in
  (* printf "symbol_table=%s\n" (Symbol_table.to_string symbol_table'); *)
  print_symbol_table symbol_table';
  assemble_with_symbol symbol_table' file_name

let spec =
  let open Command.Spec in
  empty
  +> anon ("file_name" %: string)

let command =
  Command.basic_spec
    ~summary:"Hack Assembler"
    ~readme:(fun () -> "More info")
    spec
    (fun file_name () ->
       try assemble file_name with
       | Parser.Parse_error (parser, message) -> begin
           printf "File %s, line %d:\n" file_name (Parser.line_no parser);
           printf "%s\n" message;
         end
    )

let () =
  Command.run ~version:"0.1" ~build_info:"raventid" command


