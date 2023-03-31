defmodule PitchOperationsTest do
  use ExUnit.Case, async: true

  describe "pitch_class_to_integer" do
    test "works for naturals" do
      assert PitchOperations.pitch_class_to_integer("c") == 0
      assert PitchOperations.pitch_class_to_integer("d") == 2
      assert PitchOperations.pitch_class_to_integer("e") == 4
      assert PitchOperations.pitch_class_to_integer("f") == 5
      assert PitchOperations.pitch_class_to_integer("g") == 7
      assert PitchOperations.pitch_class_to_integer("a") == 9
      assert PitchOperations.pitch_class_to_integer("b") == 11
    end

    test "works for accidentals" do
      assert PitchOperations.pitch_class_to_integer("cs") == 1
      assert PitchOperations.pitch_class_to_integer("df") == 1
      assert PitchOperations.pitch_class_to_integer("ds") == 3
      assert PitchOperations.pitch_class_to_integer("ef") == 3
      assert PitchOperations.pitch_class_to_integer("fs") == 6
      assert PitchOperations.pitch_class_to_integer("gf") == 6
      assert PitchOperations.pitch_class_to_integer("gs") == 8
      assert PitchOperations.pitch_class_to_integer("af") == 8
      assert PitchOperations.pitch_class_to_integer("as") == 10
      assert PitchOperations.pitch_class_to_integer("bf") == 10
    end

    test "works for enharmonics" do
      assert PitchOperations.pitch_class_to_integer("cf") == 11
      assert PitchOperations.pitch_class_to_integer("css") == 2
      assert PitchOperations.pitch_class_to_integer("es") == 5
      assert PitchOperations.pitch_class_to_integer("bs") == 0
      assert PitchOperations.pitch_class_to_integer("ff") == 4
    end
  end

  describe "pitches_to_intervals" do
    test "works for an ordered set" do
      assert PitchOperations.pitches_to_intervals([1, 5, 8, 9]) == [4, 3, 1]
      assert PitchOperations.pitches_to_intervals([9, 8, 5, 1]) == [1, 3, 4]
      assert PitchOperations.pitches_to_intervals([5, 8, 9, 1]) == [3, 1, 4]
    end
  end

  describe "to_normal_form" do
    test "works for a set with a single smallest ordering" do
      assert PitchOperations.to_normal_form(["a", "bf", "f"]) == ["f", "a", "bf"]
    end
  end

  test "works for a set with multiple smallest orderings but a single best-packed version" do
    assert PitchOperations.to_normal_form(["f", "af", "a", "cs"]) == ["cs", "f", "af", "a"]
  end

  test "packs towards the bottom" do
    assert PitchOperations.to_normal_form(["c", "e", "gs", "a", "b"]) == [
             "gs",
             "a",
             "b",
             "c",
             "e"
           ]
  end
end
