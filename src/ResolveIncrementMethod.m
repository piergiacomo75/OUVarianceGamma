function simulationMethod = ResolveIncrementMethod(simulationMethodString)

switch simulationMethodString
    case "ougammaincrement"
        simulationMethod = OUGammaIncrement();
    case "ousymmetricvariancegammaincrement"
        simulationMethod = OUSVGIncrement();
    case "ouvariancegammaincrement"
        simulationMethod = OUVGIncrement();
    otherwise
        error("Increment method not implemented");
end
