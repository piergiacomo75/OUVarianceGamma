function simulationMethod = ResolveIncrementMethod(incrementMethodString)

switch incrementMethodString
    case "ougammaincrement"
        simulationMethod = OUGammaIncrement();
    case "ousymmetricvariancegammaincrement"
        simulationMethod = OUSVGIncrement();
    case "ouvariancegammaincrement"
        simulationMethod = OUVGIncrement();
    case "ouvariancegammaincrementapprox2"
        simulationMethod = OUVGIncrementApprox2();        
    case "ouvariancegammaincrementapprox1"
        simulationMethod = OUVGIncrementApprox1();        
    otherwise
        error("Increment method not implemented");
end
