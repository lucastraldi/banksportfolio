using banksportfolio.Interfaces;

namespace banksportfolio.Classes
{
    public class Trade : ITrade
    {
        public double Value { get; set; }
        public string ClientSector { get; set; }

        public bool CalculateRisk(IRisk risk)
        {
            return risk.CalculateRisk(this);
        }
    }
}
