package br.com.popcode.barcode_finder;
import java.util.ArrayList;
public interface OnBarcodeReceivedListener {
    void onBarcodeFound(ArrayList<String> code);

    void onBarcodeNotFound();

    void onOutOfMemory();
}
