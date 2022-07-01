using banksportfolio.Enums;
using banksportfolio.Interfaces;

namespace banksportfolio.Classes.Risks
{
    public class MediumRisk : IRisk
    {
        public string Type { get; private set; }

        public bool CalculateRisk(ITrade trade)
        {
            if (trade.Value > 1000000 && SectorEnum.Public.ToString().Equals(trade.ClientSector))
            {
                Type = RiskEnum.MediumRisk.ToString().ToUpper();
                return true;
            }

            return false;
        }
    }
}
