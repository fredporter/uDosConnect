package selector

import "testing"

func TestMoveDownAndUp(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "One"},
			{Label: "Two"},
			{Label: "Three"},
		},
	}

	model.MoveDown()
	model.MoveDown()
	model.MoveDown()
	if model.Selected != 2 {
		t.Fatalf("expected selected index 2, got %d", model.Selected)
	}

	model.MoveUp()
	if model.Selected != 1 {
		t.Fatalf("expected selected index 1, got %d", model.Selected)
	}
}

func TestCurrentSelection(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "One", Value: "one"},
			{Label: "Two", Value: "two"},
		},
		Selected: 1,
	}

	item, ok := model.Current()
	if !ok {
		t.Fatal("expected a current item")
	}

	if item.Value != "two" {
		t.Fatalf("expected selected value two, got %s", item.Value)
	}
}

func TestFilterItems(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Workflow Alpha", Description: "step-one / running"},
			{Label: "Workflow Beta", Description: "step-two / paused"},
			{Label: "Job Run", Description: "completed"},
		},
	}

	model.EnterFilter()
	if !model.Filtering {
		t.Fatal("expected Filtering to be true after EnterFilter")
	}

	model.AppendFilter("work")
	items := model.FilteredItems()
	if len(items) != 2 {
		t.Fatalf("expected 2 filtered items for 'work', got %d", len(items))
	}

	model.ExitFilter()
	if model.Filtering {
		t.Fatal("expected Filtering to be false after ExitFilter")
	}
	if model.Filter != "" {
		t.Fatalf("expected empty filter after ExitFilter, got %q", model.Filter)
	}

	all := model.FilteredItems()
	if len(all) != 3 {
		t.Fatalf("expected all 3 items after ExitFilter, got %d", len(all))
	}
}

func TestFilterBackspace(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Alpha"},
			{Label: "Zinc"},
		},
	}

	model.EnterFilter()
	model.AppendFilter("a")
	model.AppendFilter("l")
	if model.Filter != "al" {
		t.Fatalf("expected filter 'al', got %q", model.Filter)
	}

	model.BackspaceFilter()
	if model.Filter != "a" {
		t.Fatalf("expected filter 'a' after backspace, got %q", model.Filter)
	}

	items := model.FilteredItems()
	if len(items) != 1 {
		t.Fatalf("expected 1 item for filter 'a', got %d", len(items))
	}
	if items[0].Label != "Alpha" {
		t.Fatalf("expected 'Alpha', got %q", items[0].Label)
	}
}

func TestFilterCurrentWithFilter(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Workflow Alpha", Value: "alpha"},
			{Label: "Job Beta", Value: "beta"},
		},
	}

	model.EnterFilter()
	model.AppendFilter("job")

	item, ok := model.Current()
	if !ok {
		t.Fatal("expected a current item when filter matches")
	}
	if item.Value != "beta" {
		t.Fatalf("expected value 'beta', got %q", item.Value)
	}
}

func TestFilterNoMatch(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Alpha"},
			{Label: "Beta"},
		},
	}

	model.EnterFilter()
	model.AppendFilter("zzz")
	items := model.FilteredItems()
	if len(items) != 0 {
		t.Fatalf("expected 0 items for non-matching filter, got %d", len(items))
	}

	_, ok := model.Current()
	if ok {
		t.Fatal("expected no current item when filter has no matches")
	}
}

func TestFilterResetsSelectionOnChange(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Alpha"},
			{Label: "Aleph"},
			{Label: "Beta"},
		},
	}

	model.EnterFilter()
	model.AppendFilter("al")
	model.MoveDown()
	if model.Selected != 1 {
		t.Fatalf("expected selected 1 after MoveDown, got %d", model.Selected)
	}

	// Narrowing the filter resets selection to 0.
	model.AppendFilter("p")
	if model.Selected != 0 {
		t.Fatalf("expected Selected reset to 0 after AppendFilter, got %d", model.Selected)
	}
}

func TestFilterDescriptionMatch(t *testing.T) {
	model := Model{
		Items: []Item{
			{Label: "Workflow X", Description: "step-one / running"},
			{Label: "Workflow Y", Description: "step-two / paused"},
		},
	}

	model.EnterFilter()
	model.AppendFilter("paused")
	items := model.FilteredItems()
	if len(items) != 1 {
		t.Fatalf("expected 1 item matching description 'paused', got %d", len(items))
	}
	if items[0].Label != "Workflow Y" {
		t.Fatalf("expected 'Workflow Y', got %q", items[0].Label)
	}
}
