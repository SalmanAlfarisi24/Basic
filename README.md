```java
// Mahasiswa2.java
package GUI;

/**
 * Class ini berfungsi sebagai model data (Object)
 * untuk menampung informasi mahasiswa.
 */
public class Mahasiswa2 {
    String nama;
    String nim;
    String jurusan;
    int tahunMasuk;
    int sksLulus;
    int sksTidakLulus;
    String judulSkripsi;

    // Method untuk menghitung total SKS valid
    public int getTotalValid() {
        return sksLulus - sksTidakLulus;
    }
}
```

```java
// Input_Nilai.java
package GUI;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Input_Nilai extends JFrame {

    JTextField txtNama, txtNim, txtJurusan, txtTahun, txtLulus, txtTidakLulus, txtJudul;
    JTextArea areaOutput;

    public Input_Nilai() {
        setTitle("Form Input Mahasiswa");
        setSize(500, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        JPanel panelInput = new JPanel(new GridLayout(8, 2, 5, 5));

        panelInput.add(new JLabel("Nama Mahasiswa"));
        txtNama = new JTextField();
        panelInput.add(txtNama);

        panelInput.add(new JLabel("NIM"));
        txtNim = new JTextField();
        panelInput.add(txtNim);

        panelInput.add(new JLabel("Jurusan"));
        txtJurusan = new JTextField();
        panelInput.add(txtJurusan);

        panelInput.add(new JLabel("Tahun Masuk"));
        txtTahun = new JTextField();
        panelInput.add(txtTahun);

        panelInput.add(new JLabel("Jumlah SKS Lulus"));
        txtLulus = new JTextField();
        panelInput.add(txtLulus);

        panelInput.add(new JLabel("Jumlah SKS Tidak Lulus"));
        txtTidakLulus = new JTextField();
        panelInput.add(txtTidakLulus);

        panelInput.add(new JLabel("Judul Skripsi"));
        txtJudul = new JTextField();
        panelInput.add(txtJudul);

        add(panelInput, BorderLayout.NORTH);

        areaOutput = new JTextArea();
        areaOutput.setEditable(false);
        add(new JScrollPane(areaOutput), BorderLayout.CENTER);

        JPanel panelButton = new JPanel();
        JButton btnSimpan = new JButton("Simpan");
        JButton btnReset = new JButton("Reset");
        panelButton.add(btnSimpan);
        panelButton.add(btnReset);
        add(panelButton, BorderLayout.SOUTH);

        btnSimpan.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    Mahasiswa2 m = new Mahasiswa2();
                    m.nama = txtNama.getText();
                    m.nim = txtNim.getText();
                    m.jurusan = txtJurusan.getText();
                    m.tahunMasuk = Integer.parseInt(txtTahun.getText());
                    m.sksLulus = Integer.parseInt(txtLulus.getText());
                    m.sksTidakLulus = Integer.parseInt(txtTidakLulus.getText());
                    m.judulSkripsi = txtJudul.getText();

                    areaOutput.append(
                        "Nama Mahasiswa : " + m.nama + "\n" +
                        "NIM : " + m.nim + "\n" +
                        "Jurusan : " + m.jurusan + "\n" +
                        "Tahun Masuk : " + m.tahunMasuk + "\n" +
                        "SKS Lulus : " + m.sksLulus + "\n" +
                        "SKS Tidak Lulus : " + m.sksTidakLulus + "\n" +
                        "Total SKS Valid Skripsi : " + m.getTotalValid() + "\n" +
                        "Judul Skripsi : " + m.judulSkripsi + "\n\n"
                    );
                } catch (NumberFormatException ex) {
                    JOptionPane.showMessageDialog(null, "Input angka pada Tahun/SKS tidak valid!");
                }
            }
        });

        btnReset.addActionListener(e -> {
            txtNama.setText("");
            txtNim.setText("");
            txtJurusan.setText("");
            txtTahun.setText("");
            txtLulus.setText("");
            txtTidakLulus.setText("");
            txtJudul.setText("");
            areaOutput.setText("");
        });
    }

    public static void main(String[] args) {
        new Input_Nilai().setVisible(true);
    }
}
```
