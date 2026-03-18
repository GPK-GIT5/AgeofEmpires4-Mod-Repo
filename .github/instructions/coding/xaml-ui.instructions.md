---
applyTo: "**/*.scar"
---

# XamlPresenter UI — AoE4

Rules for SCAR scripts that create custom UI panels via `UI_AddChild("ScarDefault", "XamlPresenter", ...)`.

## Fatal Patterns (Crash on First Render)

### FATAL 1: Width / Height / Opacity DataContext Binding

```xml
<!-- CRASHES — never do this -->
<Rectangle Width="{Binding [my_width]}" />
<Grid Height="{Binding [my_height]}" />
<TextBlock Opacity="{Binding [my_opacity]}" />
```

These layout properties crash XamlPresenter when bound via DataContext. The observer UI only binds Width via `ElementName`/`MultiBinding` converters — never via DataContext.

**Safe alternatives:**
- Use static widths set at XAML string creation: `string.gsub(xaml, "PLACEHOLDER", tostring(value))`
- Use full-width Rectangle with `Fill` color binding to indicate progress/status
- Use `Visibility` (with `BoolToVis` converter) to show/hide instead of shrinking

### FATAL 2: MergedDictionaries + Local Resources

```xml
<!-- CRASHES — explicit ResourceDictionary wrapper + local resource + MergedDictionaries -->
<Grid.Resources>
    <ResourceDictionary>
        <ResourceDictionary.MergedDictionaries>
            <ResourceDictionary Source="pack://..." />
        </ResourceDictionary.MergedDictionaries>
        <DropShadowEffect x:Key="Shadow" />  <!-- LOCAL RESOURCE — FATAL -->
    </ResourceDictionary>
</Grid.Resources>
```

**Safe pattern:** Use `MergedDictionaries` alone (no wrapper, no local resources):

```xml
<Grid.Resources>
    <ResourceDictionary.MergedDictionaries>
        <ResourceDictionary Source="pack://application:,,,/WPFUI;component/Styles/HUDResources.xaml" />
    </ResourceDictionary.MergedDictionaries>
</Grid.Resources>
```

If you need DropShadow effects, define them inline on the element (no `StaticResource`).

## Safe DataContext Bindings

| Property | Safe? | Notes |
|----------|-------|-------|
| Text | Yes | `Text="{Binding [field]}"` |
| Foreground | Yes | `Foreground="{Binding [color_field]}"` |
| Fill | Yes | `Fill="{Binding [fill_field]}"` |
| Visibility | Yes | With `BoolToVis` converter |
| Source (Image) | Yes | `pack://` paths only |
| Margin | Yes | Verified in ags_special_population_ui.scar |
| Width | **NO** | Fatal crash — use static or full-width |
| Height | **NO** | Fatal crash — use static |
| Opacity | **NO** | Fatal crash — use Visibility instead |

## Safe MergedDictionaries Pattern

Working examples in codebase:
- `ags_special_population_ui.scar` — bare MergedDictionaries, no local resources
- `ags_diplomacy_ui.scar` — MergedDictionaries only
- `ags_match_ui.scar` — MergedDictionaries + custom Styles (Style only, no effects)

## UI Panel Lifecycle

```lua
-- Create panel
UI_AddChild("ScarDefault", "XamlPresenter", "my_panel", xaml_string)
-- Bind data
UI_SetDataContext("my_panel", data_table)
-- Update fields (triggers re-render of bound properties)
UI_SetDataContext("my_panel", updated_table)
-- Remove panel
UI_Remove("my_panel")
```
