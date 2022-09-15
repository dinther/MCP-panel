## 3D Print instructions

It is best to generate your own STL files using the free and excellent openSCAD open source CAD software because then you can customize things like hole sizes, label captions and 3D print details such as layer heights.

But if not, then here are the details you will need to print these STL's.

### Hole test piece
![image](https://user-images.githubusercontent.com/1192916/190273148-bfafa799-c9ca-4006-8779-e3d022ad6497.png)

- Material: same as what you intend to use for the Display panel
- color": any
- Nozzle: 0.4mm
- Layer height: 0.3mm
- Infill: 15%

Start with printing the hole test piece. It is a small object that can be 3D printed quickly. Use it to check if the hole sizes work with the components you have.

### Display lid

The display lid closes the back of the MCP box and is designed to hold the Arduino Mega board. There are pegs that slot into the PCB holes. No screws are required as the wires press onto and hold the board in place.
Print it with the back flat on the build plate.

- Material: PLA (PETG if used in hot environments)
- Color: gray
- Nozzle: 0.4mm
- Layer height: 0.3mm
- Infill: 15%

### Display panel
The main panel is a composite of two material colors. There is the main body in gray and the text and symbol inlays in white.

![image](https://user-images.githubusercontent.com/1192916/190298700-c256e732-33a4-4015-a897-6c85040f43eb.png)

Load the main body into the slicer and place it with the face (Text side) down on the build plate. Then import the display panel text stl and also place it face down on the build plate.
Align the two objects as accurately as possible.

You can allocate a different extruder to each object. I will write a tutorial later on how to create amazing dual material panel prints later.

- Material: PLA (PETG if used in hot environments)
- Color: gray / white
- Nozzle: 0.4mm
- Layer height: 0.3mm
- Infill: 15%
