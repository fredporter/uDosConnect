export type PaletteItem = {
  id: string;
  title: string;
  command: string;
};

export const paletteItems: PaletteItem[] = [
  { id: "binder-create", title: "Create Binder", command: "#binder create demo-binder" },
  { id: "binder-list", title: "List Binders", command: "#binder list" },
  { id: "vault-health", title: "Vault Health", command: "#vault health" },
  { id: "wizard-assist", title: "Wizard Assist", command: "#wizard assist task:demo" }
];
