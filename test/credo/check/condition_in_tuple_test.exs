defmodule Credo.Check.Refactor.ConditionInTupleTest do
  use Credo.TestHelper

  @described_check Credo.Check.Refactor.ConditionInTuple

  test "it should NOT report a normal tuple" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        {parameter1, parameter2}
      end
    end
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report a normal condition" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        if parameter1 do
          parameter2
        end
      end
    end
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should report a condition in a 1-element tuple" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        {if parameter1 do
          parameter2
        end}
      end
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end

  # 2-element tuple is a special case
  test "it should report a condition in the first element of a tuple" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        {if parameter1 do
          parameter2
        end,
        parameter2}
      end
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end

  # 2-element tuple is a special case
  test "it should report a condition in the second element of a tuple" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        {parameter1,
        if parameter1 do
          parameter2
        end}
      end
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end

  test "it should report a condition in a 3-element tuple" do
    """
    defmodule CredoSampleModule do
      def some_function(parameter1, parameter2) do
        {parameter1,
        case parameter1 do
          _ -> parameter2
        end,
        parameter2}
      end
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end
end
