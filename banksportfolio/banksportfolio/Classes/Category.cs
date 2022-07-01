using banksportfolio.Enums;
using banksportfolio.Factories;
using banksportfolio.Interfaces;

namespace banksportfolio.Classes
{
    public class Category
    {
        private readonly List<ITrade> _portfolio;
        public Category(List<ITrade> portfolio)
        {
            _portfolio = portfolio;
        }

        public List<string> GetCategories()
        {
            var categories = new List<string>();

            foreach (var trade in _portfolio)
            {
                categories.Add(GetRiskType(trade));
            }

            return categories;
        }

        private string GetRiskType(ITrade trade)
        {
            var risks = new List<IRisk>();

            foreach (var risk in Enum.GetValues(typeof(RiskEnum)).Cast<RiskEnum>())
                risks.Add(RiskFactory.Create(risk));

            foreach (var risk in risks)
            {
                if (risk.CalculateRisk(trade))
                {
                    return risk.Type;
                }
            }

            return "It does not match any implemented risk";
        }
    }
}
