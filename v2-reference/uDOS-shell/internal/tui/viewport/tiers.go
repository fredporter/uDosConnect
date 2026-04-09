package viewport

type Tier struct {
	Name   string
	Width  int
	Height int
	Label  string
}

var tiers = []Tier{
	{Name: "V0", Width: 25, Height: 25, Label: "V0 25x25"},
	{Name: "V1", Width: 40, Height: 25, Label: "V1 40x25"},
	{Name: "V2", Width: 64, Height: 32, Label: "V2 64x32"},
	{Name: "V3", Width: 80, Height: 40, Label: "V3 80x40"},
	{Name: "V4", Width: 100, Height: 40, Label: "V4 100x40"},
	{Name: "V5", Width: 120, Height: 50, Label: "V5 120x50"},
	{Name: "V6", Width: 80, Height: 45, Label: "V6 80x45"},
	{Name: "V7", Width: 120, Height: 67, Label: "V7 120x67"},
}

func Match(width int, height int) Tier {
	matched := tiers[0]

	for _, tier := range tiers {
		if width >= tier.Width && height >= tier.Height {
			matched = tier
		}
	}

	return matched
}
