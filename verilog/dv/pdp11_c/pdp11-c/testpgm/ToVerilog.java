import java.io.*;

public class ToVerilog {
	public static void main(String[] args) {
		try {
			FileInputStream fis = new FileInputStream(new File(args[0]));
			int ctr = 0;
			if(fis.read() != 0x08 || fis.read() != 0x01) { fis.close(); throw new Exception("Invalid header"); }
			int text_size = fis.read() | (fis.read() << 8);
			int data_size = fis.read() | (fis.read() << 8);
			int bss_size = fis.read() | (fis.read() << 8);
			//System.out.println(String.format(".text\t\t%04x\r\n.data\t\t%04x\r\n.bss\t\t%04x\r\ntotal\t\t%04x\r\n", text_size, data_size, bss_size, text_size + data_size + bss_size));
			fis.skip(8);
			FileOutputStream fos = new FileOutputStream(new File(args[0] + ".bin"));
			while(fis.available() > 1) {
				int a = fis.read();
				int b = fis.read();
				System.out.print(String.format("%02x%02x", b, a));
				fos.write(a);
				fos.write(b);
				ctr+=2;
				if(ctr % 16 == 0) System.out.println();
				else System.out.print(" ");
				if(ctr == text_size && (ctr & 255) != 0) {
					//Pad to nearest 256-byte boundary
					while((ctr & 255) != 0) {
						System.out.print("0000");
						ctr+=2;
						if(ctr % 16 == 0) System.out.println();
						else System.out.print(" ");
						fos.write(0);
						fos.write(0);
					}
				}
			}
			fos.close();
			fis.close();
			System.out.println();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
