defmodule Cards do
  @moduledoc """
  Documentation for `Cards`.
  """

  @doc """
    Hello world.

  ## Examples

      iex> Cards.hello()
      "hi there"

  """
  def hello do
    "hi there"
  end

  @doc """
  Return a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = [
      "Ace",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Jack",
      "Queen",
      "King"
    ]

    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    # Conseguir una unica lista con todas las combinaciones de cartas y palos

    # 1 doble bucle y aplanar la lista
    # cards =for suit <-suits do
    #   for value  <- values  do
    #     "#{value} of #{suit}"
    #   end
    # end
    # List.flatten(cards)

    # 2 un bucle con doble recorrido mejor por tener menos código
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
    Shuffle a deck of cards, the 'deck' argument is the list of cards to shuffle
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Check if 'hand' exists withing the 'deck'

  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck,"Ace of Spades")
      true
      iex> {hand,deck} = Cards.deal(deck,1)
      iex> Cards.contains?(deck,"Ace of Spades")
      false
      iex> Cards.contains?(deck,hand)
      false

  """
  def contains?(deck, hand) do
    Enum.member?(deck, hand)
  end

  @doc """
    Divides a 'deck' into a hand with 'hand_size' elements and the remainder of the deck.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {hand,_} = Cards.deal(deck,1)
      iex> hand
      ["Ace of Spades"]

      iex> deck = Cards.create_deck()
      iex> {hand,_} = Cards.deal(deck,2)
      iex> hand
      ["Ace of Spades", "Two of Spades"]

      iex> deck = Cards.create_deck()
      iex> {hand,_} = Cards.deal(deck,3)
      iex> hand
      ["Ace of Spades", "Two of Spades", "Three of Spades",]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _} -> "File does not exists"
    end
  end

  @doc """
    Create a deck of cards, shuffle and divides a 'deck' into a hand with 'hand_size' elements and the remainder of the deck.

  ## Examples

      iex> {hand,deck} = Cards.create_hand(2)
      iex> Cards.contains?(deck,hand)
      false

  """
  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end
end
