import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.awt.*;

public class PlacementPreview {
	public static class Macro {
		public int x,y,w,h;
		public Color c;
		public String name;
		public Macro(int x, int y, int w, int h, Color c, String name) {
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			this.c = c;
			this.name = name;
		}
	}
	
	public static void main(String[] args) {
		BufferedImage img = new BufferedImage(2968, 2968, BufferedImage.TYPE_INT_RGB);
		
		Macro[] macros = new Macro[] {
			new Macro(950, 1200, 750, 700, Color.GREEN, "Multiplexer"), //Multiplexer
			new Macro(200, 250, 1150, 800, Color.RED, "SID"), //wrapped_sid
			new Macro(1450, 250, 180, 180, new Color(255, 128, 16), "LED Blinker Test"), //blinker
			new Macro(1850, 250, 250, 250, new Color(32, 64, 240), "SN76489"), //wrapped_sn76489
			new Macro(300, 2375, 450, 528, new Color(240, 128, 32), "Avali Logo"), //avali_logo
			new Macro(2300, 250, 475, 500, new Color(240, 64, 64), "QCPU"), //wrapped_qcpu
			new Macro(1500, 800, 185, 185, new Color(166, 166, 0), "MC14500"), //wrapped_mc14500
			new Macro(200, 1200, 255, 255, new Color(166, 32, 166), "AY8913"), //wrapped_ay8913
			new Macro(700, 1300, 130, 130, new Color(166, 32, 255), "Hellorld"),
			new Macro(600, 1600, 230, 230, new Color(166, 255, 86), "TBB1143"),
			new Macro(950, 2050, 1700, 800, new Color(23, 190, 120), "AS-11 (PDP-11)"),
			new Macro(1775, 825, 1150, 1150, new Color(19, 182, 222), "Tholin RISCV (RV32IM)"),
			new Macro(250, 1575, 230, 230, new Color(88, 111, 177), "Diceroll"),
			new Macro(300, 1950, 120, 120, new Color(1, 88, 255), "UE-1 (UE14500)"),
		};

		/*Macro[] macros = new Macro[] {
			new Macro(1322, 250, 275, 275, Color.BLACK),
			new Macro(1850, 500, 90, 90, Color.BLACK),
			new Macro(2000, 500, 90, 90, Color.BLACK),
			
			new Macro(167, 2620, 750, 750, Color.GREEN),
			new Macro(1085, 2620, 750, 750, Color.GREEN),
			new Macro(2002, 2620, 750, 750, Color.GREEN),
			
			new Macro(167, 1720, 750, 750, Color.GREEN),
			new Macro(1085, 1720, 750, 750, Color.RED),
			new Macro(2002, 1720, 750, 750, Color.RED),
			
			new Macro(167, 820, 750, 750, Color.RED),
			new Macro(1085, 820, 750, 750, Color.RED),
		};*/

		Graphics2D g = (Graphics2D)img.getGraphics();
		g.setFont(new Font("Dialog", Font.PLAIN, 48));
		for(int i = 0; i < img.getWidth(); i++) for(int j = 0; j < img.getHeight(); j++) img.setRGB(i, j, 0xFFFFFF);
		for(int i = 0; i < macros.length; i++) {
			int x = macros[i].x;
			int y = img.getHeight() - 1 - macros[i].y;
			int w = macros[i].w;
			int h = macros[i].h;
			int rgb = macros[i].c.getRGB();
			
			for(int k = 0; k < 8; k++) {
			
				for(int j = 0; j < w; j++) {
					img.setRGB(x + j, y - k, rgb);
					img.setRGB(x + j, y - h + k, rgb);
				}
				for(int j = 0; j < h; j++) {
					img.setRGB(x + k, y - j, rgb);
					img.setRGB(x + w - 1 - k, y - j, rgb);
				}
				
				g.setColor(macros[i].c);
				g.drawString(macros[i].name, x - 12, y - h - 12);
			}
		}
		
		for(int i = 0; i < img.getWidth(); i++) {
			img.setRGB(i, 0, 0);
			img.setRGB(i, img.getHeight() - 1, 0);
		}
		
		for(int j = 0; j < img.getHeight(); j++) {
			img.setRGB(0, j, 0);
			img.setRGB(img.getWidth() - 1, j, 0);
		}
		
		try {
			ImageIO.write(img, "png", new File("placements.png"));
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
