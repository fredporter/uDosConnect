package contracts

type KnowledgeStamp struct {
	RuntimeServicesVersion string            `json:"runtime_services_version"`
	FoundationVersion      string            `json:"foundation_version"`
	Contracts              map[string]string `json:"contracts"`
}

func LoadKnowledgeStamp() (KnowledgeStamp, error) {
	runtimeManifest, _, err := LoadRuntimeServiceManifest()
	if err != nil {
		return KnowledgeStamp{}, err
	}

	stamp := KnowledgeStamp{
		RuntimeServicesVersion: runtimeManifest.Version,
		FoundationVersion:      runtimeManifest.Extends,
		Contracts:              map[string]string{},
	}

	for name := range contractFilenames {
		contract, _, err := LoadNamedContract(name)
		if err != nil {
			return KnowledgeStamp{}, err
		}
		stamp.Contracts[name] = contract.Version
	}

	return stamp, nil
}
