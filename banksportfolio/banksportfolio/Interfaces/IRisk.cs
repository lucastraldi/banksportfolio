namespace banksportfolio.Interfaces
{
    public interface IRisk
    {
        string Type { get; }

        bool CalculateRisk(ITrade trade);
    }
}
