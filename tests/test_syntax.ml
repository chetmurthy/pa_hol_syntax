open OUnit2
open Pa_ppx_base
open Pa_ppx_testutils.Papr_util
open Pa_ppx_testutils.Testutil2

let pa1 s =
  s |> PAPR.Implem.pa1 |> List.hd |> fst
;;

let pa_top_phrase s = 
  s |> Stream.of_string |> Grammar.Entry.parse Pcaml.top_phrase
;;

let assert_str_item_equal e1 e2 =
  assert_equal ~cmp:Reloc.eq_str_item
    ~printer:Pp_MLast.show_str_item
    e1 e2
;;

let eq_str_item_option e1 e2 =
  match (e1, e2) with
    (None, None) -> true
  | (Some e1, Some e2) -> Reloc.eq_str_item e1 e2
  | _ -> false
;;

let test1 ctxt =
  assert_str_item_equal
    (pa1 {| parse_term "foo" |}) (pa1 {| `foo` |})
; assert_str_item_equal
    (pa1 {| then_ e1 e2 |}) (pa1 {| e1 THEN e2 |})
; assert_str_item_equal
    (pa1 {| then_ |}) (pa1 {| (THEN) |})
; assert_str_item_equal
    (pa1 {| (THEN) e1 e2 |}) (pa1 {| e1 THEN e2 |})
; assert_str_item_equal
    (pa1 {| (o) |}) (pa1 {| (o) |})
; assert_str_item_equal
    (pa1 {| (o) e1 e2 |}) (pa1 {| e1 o e2 |})
; assert_equal ~cmp:eq_str_item_option
    (pa_top_phrase {| let it = e1 ;; |}) (pa_top_phrase {| e1 ;; |})
; assert_str_item_equal
    (let loc = Ploc.dummy in <:str_item< Formula.True >>)
    (pa1 {| Formula.True |})
;;

let suite = "test_syntax" >::: [
    "test1"   >:: (exn_wrap_result test1)
  ]

let _ = 
if not !Sys.interactive then
  run_test_tt_main suite
else ()
