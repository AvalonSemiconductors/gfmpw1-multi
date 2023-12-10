import java.io.*;

public class ToVerilog {
	public static void main(String[] args) {
		try {
			FileInputStream fis = new FileInputStream(args[0]);
			BufferedWriter bw = new BufferedWriter(new FileWriter(new File("../../pgm.txt")));
			int counter = 0;
			while(fis.available() > 0) {
				int i = fis.read();
				bw.write(String.format("%02x ", i));
				counter++;
				if(counter % 16 == 0) bw.newLine();
			}
			bw.newLine();
			fis.close();
			bw.close();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
