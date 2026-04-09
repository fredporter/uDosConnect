# Merge guide

Unzip this add-on into the root of the prior `udos-ubuntu-v2.2` scaffold.

Suggested resulting layout:

- `packages/udos-doc-format/`
- `services/okd/`
- `network/beacon/hostapd/`
- `network/beacon/dnsmasq/`
- `network/beacon/scripts/`

## Immediate next steps

1. Add the full v2.2 spec text into your main spec document.
2. Wire `services/okd` into your API layer.
3. Connect WordPress or your local portal UI to OK endpoints.
4. Replace the OpenRouter scaffold call with a real HTTP client.
5. Add GPT4All or another local model endpoint into `LocalModelClient`.
6. If retaining `Wizard`, use it as a broker that delegates into this scaffold
   rather than as a competing runtime authority.
