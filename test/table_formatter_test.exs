defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  @simple_test_data [
    [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
    [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
  ]

  @headers [:c1, :c2, :c4]

  def split_with_three_columns do
    TF.split_into_columns(@simple_test_data, @headers)
  end

  test "split_with_three_columns" do
    columns = split_with_three_columns()
    assert length(columns) == length(@headers)
    assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
    assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "empty_widths" do
    widths = TF.widths_of(TF.split_into_columns([], @headers))
    assert widths == [5, 6, 7]
  end

  test "correct_widths" do
    widths = TF.widths_of(split_with_three_columns())
    assert widths == [5, 6, 7]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "Output is correct" do
    result =
      capture_io(fn ->
        TF.print_table_for_columns(@simple_test_data, @headers)
      end)

    assert result ==
             "r1 c1r2 c1r3 c1r4 c1r1 c2r2 c2r3 c2r4++c2r1+++c4r2 c4r3 c4r4 c4\nc1    | c2     | c4     \n------+--------+--------\nr1 c1 | r1 c2  | r1+++c4\nr2 c1 | r2 c2  | r2 c4  \nr3 c1 | r3 c2  | r3 c4  \nr4 c1 | r4++c2 | r4 c4  \n"
  end
end
