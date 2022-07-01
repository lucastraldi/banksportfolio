using banksportfolio.Classes.Risks;
using banksportfolio.Enums;
using banksportfolio.Interfaces;

namespace banksportfolio.Factories
{
    public class RiskFactory
    {
        public static IRisk Create(RiskEnum risk)
        {
            switch (risk)
            {
                case RiskEnum.LowRisk:
                    return new LowRisk();
                case RiskEnum.MediumRisk:
                    return new MediumRisk();
                case RiskEnum.HighRisk:
                    return new HighRisk();
                default:
                    throw new NotImplementedException();
            }
        }
    }
}
