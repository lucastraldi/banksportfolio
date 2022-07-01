using banksportfolio.Classes;
using banksportfolio.Enums;
using banksportfolio.Interfaces;

var portfolio = new List<ITrade> {
    new Trade { Value = 2000000, ClientSector = SectorEnum.Private.ToString() },
    new Trade { Value = 400000, ClientSector = SectorEnum.Public.ToString() },
    new Trade { Value = 500000, ClientSector = SectorEnum.Public.ToString() },
    new Trade { Value = 3000000, ClientSector = SectorEnum.Public.ToString() },
};

var categories = new Category(portfolio).GetCategories();

var categoriesForDisplay = string.Join(", ", categories.Select(x => $"\"{x}\""));
Console.WriteLine("tradeCategories = {" + categoriesForDisplay + "}");
Console.ReadKey();