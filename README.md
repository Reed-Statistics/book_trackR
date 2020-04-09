# book_trackR

The goal of `book_trackR` is to track the prices of used books across a variety of used bookstores, allowing the user to buy used book when prices are the lowest while avoiding buying from a certain company when the opportunity cost of doing so is sufficiently low.

In order to do so, `book_trackR` will:
1. store a list of books the user is interested in
2. store a list of inventory + prices for each book
3. each day, update the inventory + prices list
4. alert the user when a good deal is available

## Tables (will probably change as I think through this more)

1. Books
  1. Title
  2. Category (assigned by user?)
  3. Author
  4. ISBN (use as ID)
2. Inventory
  1. ISBN (ID to pair with `Books` table)
  2. Quality (e.g. fair, like new, very good)
  3. Price (including shipping? otherwise store shipping separately)
  4. Seller (e.g. Amazon, Half-Priced Books, Powells)

## Data Sources

1. Amazon
  1. API seems to only be available for sellers and affiliates (so I guess I'll scrape)
2. Half-Priced Books
  1. Terms of Use explicitly exclude crawling :(
  2. No obvious API
3. Powells
  1. The Powell's Partner program has inventory data, but is not accepting new applicants right now (presumably due to covid19)