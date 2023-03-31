defmodule PitchOperations do
  def to_normal_form(set) do
    rotations =
      for i <- 0..(length(set) - 1) do
        {Enum.drop(set, i) ++ Enum.take(set, i), i}
      end
      |> Enum.map(fn {set, _} = r ->
        Tuple.insert_at(r, 0, Enum.map(set, &pitch_class_to_integer/1))
      end)
      |> Enum.map(fn r ->
        Tuple.insert_at(r, 0, total_interval(elem(r, 0)))
      end)

    min_span = Enum.map(rotations, &elem(&1, 0)) |> Enum.min()

    possible_normal_forms = Enum.filter(rotations, &(elem(&1, 0) == min_span))

    case possible_normal_forms do
      [one_option] -> elem(one_option, 2)
      _ -> find_best_packed_candidate(possible_normal_forms)
    end
  end

  defp total_interval(l) do
    first = List.first(l)
    last = List.last(l)

    case first <= last do
      true -> last - first
      false -> last + 12 - first
    end
  end

  defp find_best_packed_candidate(candidates) do
    candidates =
      candidates
      |> Enum.map(fn c ->
        intervals = pitches_to_intervals(elem(c, 1))

        [
          Tuple.insert_at(c, 0, Enum.scan(intervals, &+/2)) |> Tuple.insert_at(1, 0),
          Tuple.insert_at(c, 0, Enum.scan(Enum.reverse(intervals), &+/2)) |> Tuple.insert_at(1, 1)
        ]
      end)
      |> List.flatten()

    best_packed = Enum.min_by(candidates, &{elem(&1, 0), elem(&1, 1)})
    elem(best_packed, 4)
    # possible_forms = Enum.filter(candidates, &(elem(&1, 0) == elem(best_packed, 0)))
    #
    # case possible_forms do
    #   [one_option] -> elem(one_option, 4)
    #   [one_of_many | _] -> elem(one_of_many, 4)
    # end
  end

  def pitches_to_intervals(pitches) do
    Enum.chunk_every(pitches, 2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      case abs(b - a) do
        n when n > 6 -> 12 - n
        n -> n
      end
    end)
  end

  def pitch_class_to_integer("cf"), do: 11
  def pitch_class_to_integer("c"), do: 0
  def pitch_class_to_integer("cs"), do: 1
  def pitch_class_to_integer("css"), do: 2

  def pitch_class_to_integer("dff"), do: 0
  def pitch_class_to_integer("df"), do: 1
  def pitch_class_to_integer("d"), do: 2
  def pitch_class_to_integer("ds"), do: 3
  def pitch_class_to_integer("dss"), do: 4

  def pitch_class_to_integer("eff"), do: 2
  def pitch_class_to_integer("ef"), do: 3
  def pitch_class_to_integer("e"), do: 4
  def pitch_class_to_integer("es"), do: 5

  def pitch_class_to_integer("ff"), do: 4
  def pitch_class_to_integer("f"), do: 5
  def pitch_class_to_integer("fs"), do: 6
  def pitch_class_to_integer("fss"), do: 7

  def pitch_class_to_integer("gff"), do: 5
  def pitch_class_to_integer("gf"), do: 6
  def pitch_class_to_integer("g"), do: 7
  def pitch_class_to_integer("gs"), do: 8
  def pitch_class_to_integer("gss"), do: 9

  def pitch_class_to_integer("aff"), do: 7
  def pitch_class_to_integer("af"), do: 8
  def pitch_class_to_integer("a"), do: 9
  def pitch_class_to_integer("as"), do: 10
  def pitch_class_to_integer("ass"), do: 11

  def pitch_class_to_integer("bff"), do: 9
  def pitch_class_to_integer("bf"), do: 10
  def pitch_class_to_integer("b"), do: 11
  def pitch_class_to_integer("bs"), do: 0
end
