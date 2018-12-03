# Unity SDF Antialiasing

This is an exploration of antialiasing methods available when rendering text using signed distance fields (SDF).

#### Three methods are implemented so far:
- **Simple SDF** rendering.
- **SuperSampled SDF** rendering (samples may be combined using an interpolated value of *min*, *max* or *average*).
- **SubPixel SDF** rendering (we assume a pixel horizontally divided in red, green and blue components).

#### Notes:
- all methods use a *sigmoid* function to bring contrast to SDF sampled values.
- **SuperSampled SDF** can be thought of as a *pooling layer* followed by a *sigmoid activation* in *convolutional neural networks* terminology.
