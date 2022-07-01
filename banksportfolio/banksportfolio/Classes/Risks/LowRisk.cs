using banksportfolio.Enums;
using banksportfolio.Interfaces;

namespace banksportfolio.Classes.Risks
{
    public class LowRisk : IRisk
    {
        public string Type { get; private set; }

        public bool CalculateRisk(ITrade trade)
        {
            if (trade.Value < 1000000 && SectorEnum.Public.ToString().Equals(trade.ClientSector))
            {
                Type = RiskEnum.LowRisk.ToString().ToUpper();
                return true;
            }

            return false;
        }
    }
}
