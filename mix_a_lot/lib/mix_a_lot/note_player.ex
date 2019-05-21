defmodule MixALot.NotePlayer do
  @moduledoc """
  This module plays a note
  """

  @doc """
  Takes a frequency, duration and volume and plays a note

  ## Examples

  # When arguments are valid
      iex> MixALot.NotePlayer.play(440, 0.75, 50)
      :ok

  # When arguments are invalid
      iex> MixALot.NotePlayer.play(440, "bad_duration", 50)
      :error
  """
  @spec play(frequency :: Integer.t(), duration :: Decimal.t(), volume :: Integer.t()) :: :ok | :error
  def play(frequency, duration, volume) do
    call("""
      echo 'foo' |  awk '{ for (i = 0; i < #{duration}; i+= 0.00003125) \
      printf("%08X\\n", #{volume}*sin(#{frequency}*3.14*exp((a[$1 % 8]/12)\
      *log(2))*i)) }' | xxd -r -p | aplay -c 2 -f S32_LE -r 28000
    """)
  end

  defp call(command) do
    case System.cmd("sh", ["-c", command]) do
      {_, 0} -> :ok
      _ -> :error
    end
  end
end
