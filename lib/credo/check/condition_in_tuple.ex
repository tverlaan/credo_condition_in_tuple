defmodule Credo.Check.Refactor.ConditionInTuple do
  @moduledoc """
  Having a condition in a tuple makes your code harder to follow. You have
  to scan the text inside the tuple to see where the comma is and where the
  closing curly brace is. By avoiding this it is more clear to the reader
  what the data looks like.

  The result of a function here is clear:

      def condition(foo) do
        outcome =
          if foo do
            :ok
          else
            :nok
          end

        {outcome, foo}
      end

  The result of this function might be harder to comprehend:

      def condition(foo) do
        {if foo do
          :ok
        else
          :nok
        end, foo}
      end
  """

  @explanation [check: @moduledoc]
  @short_explanation "Tuples should not contain conditions"
  @condition_ops [:if, :unless, :case, :cond]

  use Credo.Check

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  # tuples of all sizes except 2
  defp traverse({:{}, _, arguments} = ast, issues, issue_meta) do
    found_issues = Credo.Code.prewalk(arguments, &find_issues(&1, &2, issue_meta))
    {ast, issues ++ found_issues}
  end

  # 2-element tuple with condition in first element
  defp traverse({{condition, meta, _}, _} = ast, issues, issue_meta)
       when condition in @condition_ops do
    new_issue = issue_for(issue_meta, meta[:line], condition)
    {ast, issues ++ [new_issue]}
  end

  # ignore :do blocks (might accidentally ignore 2-element tuples with first value :do)
  defp traverse({:do, _} = ast, issues, _) do
    {ast, issues}
  end

  # 2-element tuple with condition in second element
  defp traverse({_, {condition, meta, _}} = ast, issues, issue_meta)
       when condition in @condition_ops do
    new_issue = issue_for(issue_meta, meta[:line], condition)
    {ast, issues ++ [new_issue]}
  end

  defp traverse(ast, issues, _) do
    {ast, issues}
  end

  # find issues inside a tuple
  defp find_issues({condition, meta, _} = ast, issues, issue_meta)
       when condition in @condition_ops do
    new_issue = issue_for(issue_meta, meta[:line], condition)
    {ast, issues ++ [new_issue]}
  end

  defp find_issues(ast, issues, _) do
    {ast, issues}
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(issue_meta,
      message: @short_explanation,
      line_no: line_no,
      trigger: trigger
    )
  end
end
