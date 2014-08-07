Pixel
=====

A simple pixel art editor written in Swift.

![Screenshot](https://raw.githubusercontent.com/tjhancocks/Pixel/master/Preview%20Images/PixelPreviewSMB.png)

###About the current version
Currently this editor is extremely basic. You can not yet change the size of the canvas, zoom-in or out (it's set to 1000% currently) and you can only paint in one colour. However this is basically the
foundation work that is being laid for a tool that will be used by myself for [QuantumCarrot](http://quantumcarrot.com) in the future.

Current features of the editor are:

- Colour Selection
- Layers (Naming, Addition, Deletion)
- New Documents (Naming, Canvas Sizing, Base Image - not quite functional yet)
- Layer Visibility
- Layer Opacity
- Canvas Scaling/Zooming
- Brush/Pen Sizes (Slightly broken, and need to explore a better way of presenting the option)
- Export to PNG, etc (No fully in, as it needs to give options to export to JPG and scale)


Planned features of the editor include:
- Shapes (Lines, Rectangles, Ovals, etc)
- Flood Filling
- Layer Blending
- Saving/Opening using a custom file format to allow the Colour Swatches and Layers to be saved


###Why?
In all honesty, I've wanted an excuse to play around with Swift in a none game project, and decided a Pixel Art Editor would be pretty fun and useful to make.


###License
The MIT License (MIT)

Copyright (c) 2014 Tom Hancocks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
