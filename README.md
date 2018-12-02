# Unity SDF Antialiasing

This is an exploration of antialiasing methods available when rendering text using signed distance fields (SDF).

Three methods are implemented so far:
- **simple SDF** rendering
- **supersampled SDF** rendering (samples may be combined using an interpolated value of *min*, *max* or *average*)
- **subpixel SDF** rendering (we assume a pixel horizontally divided in red, green and blue components)
