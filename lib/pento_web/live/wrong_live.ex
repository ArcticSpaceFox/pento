defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "make a guess:", random_number: Enum.random(1..10))}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    <button phx-click="reset">Try again!</button>
    <p>
      Started <%= time() %>
    </p>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    cond do
      String.to_integer(guess) == socket.assigns.random_number ->
        {
          :noreply,
          assign(
            socket,
            message: "You got it! New number new challenge...",
            score: socket.assigns.score + 5,
            random_number: Enum.random(1..10)
          )
        }

      true ->
        {
          :noreply,
          assign(
            socket,
            message: if String.to_integer(guess) > socket.assigns.random_number do "Your guess: #{guess}. Too big " else "Your guess: #{guess}. Too smol " end,
            score: socket.assigns.score - 1
          )
        }
    end
  end

  def handle_event("reset", _, socket) do
    {
      :noreply,
      assign(
        socket,
        random_number: Enum.random(1..10),
        message: "make a guess:",
        score: 0
      )
    }
  end
end
