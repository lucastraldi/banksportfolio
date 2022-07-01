using banksportfolio.Enums;
using banksportfolio.Interfaces;

namespace banksportfolio.Classes.Risks
{
    public class HighRisk : IRisk
    {
        public string Type { get; private set; }

        public bool CalculateRisk(ITrade trade)
        {
            if (trade.Value > 1000000 && SectorEnum.Private.ToString().Equals(trade.ClientSector))
            {
                Type = RiskEnum.HighRisk.ToString().ToUpper();
                return true;
            }

            return false;
        }
    }
}
