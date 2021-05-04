global MouseOps

fn CreateMouseOps forceRecompile:on =
(
	if forceRecompile or not iskindof MouseOps dotnetobject or (MouseOps.GetType()).name != "Assembly" do
	(
      source = ""
      source += "using System;"
      source += "using System.Runtime.InteropServices;"
      source += "public class VMouse"
      source += "{"
      source += "	private const int VK_LBUTTON = 0x01;"
      source += "	private const int VK_RBUTTON = 0x02;"
      source += "	private const int VK_MBUTTON = 0x04;"
      source += "	private const int KEY_PRESSED = 0x80;"
      source += "	[DllImport(\"user32.dll\", CharSet = CharSet.Auto, ExactSpelling = true)]"
      source += "	public static extern short GetKeyState(int virtualKeyCode);"
      source += "	public int IsPressed(int key) { return (GetKeyState(key) & KEY_PRESSED); }"
      source += "	public int MouseButtons()"
      source += "	{"
      source += "		int buttons = 0;"
      source += "		buttons += IsPressed(VK_LBUTTON) >> 5;"
      source += "		buttons += IsPressed(VK_MBUTTON) >> 6;"
      source += "		buttons += IsPressed(VK_RBUTTON) >> 7;"
      source += "		return buttons;"
      source += "	}"
      source += "}"		
      
      csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
	  compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
	  compilerParams.ReferencedAssemblies.Add "System.dll"
      
	  compilerParams.GenerateInMemory = true
	  compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
      
	  MouseOps = compilerResults.CompiledAssembly
	  MouseOps.CreateInstance "VMouse"
	)
)

global VMouse = CreateMouseOps()
global getMouseButtons = VMouse.MouseButtons
