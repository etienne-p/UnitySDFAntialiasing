# Unity SDF Antialiasing

This is an exploration of antialiasing methods available when rendering text using signed distance fields (SDF).

#### The following methods are implemented so far:
- **Simple SDF** rendering.
- **SuperSampled SDF** rendering (samples may be combined using an interpolated value of *min*, *max* or *average*).
- **SubPixel SDF** rendering (we assume a pixel horizontally divided in red, green and blue components).
- **SubPixel SuperSampled SDF**, same as **SubPixel SDF** except we take 2 samples per subpixel (averaged).
