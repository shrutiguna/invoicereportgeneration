# Invoice Extraction Bot

A UiPath RPA bot that reads a PDF invoice, extracts all key fields and line items using Regex, and saves them into a professionally formatted Excel file with two sheets.

---

## What It Does

1. Opens and reads the PDF using the **Read PDF Text** activity
2. Extracts header fields using **Regex Matches** activities:
   - Invoice Number, Invoice Date, Due Date, PO Reference
   - Payment Terms, Currency
   - Vendor Name, Vendor GST, Vendor Address
   - Client Name, Client GST, Client Address
   - Sub Total, CGST, SGST, Gross Total, TDS, Net Payable
   - Payment Status, Bank Name, Account Number, IFSC Code
3. Dynamically extracts all 6 line items using **Regex + For Each** loop (Description, SAC Code, Qty, Rate, Amount, GST%)
4. Writes Invoice Header fields into **Sheet 1** ("Invoice Header") of the output Excel
5. Writes Line Items into **Sheet 2** ("Line Items") of the output Excel
6. Applies professional formatting via **VBA** (dark blue headers, alternating row colors, gold column headers)
7. Shows a message box: **"Invoice INV-2024-0087 extracted successfully!"**
8. Generates execution logs and error logs

---

## Prerequisites

| Requirement | Version |
|---|---|
| UiPath Studio | Community Edition 2023.10+ |
| Project Type | Windows (Modern Design) |
| UiPath.Excel.Activities | **2.24.2** |
| UiPath.PDF.Activities | **3.24.0** |
| UiPath.System.Activities | 26.x |
| Expression Language | VB.NET |

---

## Project Structure

    InvoiceReport/
    ├── Main.xaml                          # Main workflow
    ├── sample_invoice.pdf                 # Input PDF invoice
    ├── format_invoice.vbs                 # VBA script for Excel formatting
    ├── invoice_extraction_output.xlsx     # Generated output (after running)
    ├── invoiceData.txt                    # Debug output of raw PDF text
    ├── InvoiceBot_Log.txt                 # Execution log
    ├── ErrorLog.txt                       # Error log (if errors occur)
    ├── project.json                       # UiPath project config
    ├── project.uiproj                     # UiPath project file
    └── entry-points.json                  # Entry point config

---

## Input

`sample_invoice.pdf` — A GST-format invoice from TechNova Solutions Pvt. Ltd. to Infosys Technologies Ltd. containing 6 line items for IT services.

---

## Extracted Fields

### Invoice Header (Sheet 1 — 22 fields)

| Field | Example Value |
|---|---|
| Invoice Number | INV-2024-0087 |
| Invoice Date | 15 March 2024 |
| Due Date | 14 April 2024 |
| PO Reference | PO-INF-7821 |
| Payment Terms | Net 30 Days |
| Currency | INR (Indian Rupee) |
| Vendor Name | TechNova Solutions |
| Vendor GST | 33AABCT1332L1ZX |
| Vendor Address | #42, Anna Salai, Chennai – 600002, Tamil Nadu, India |
| Client Name | Infosys Technologies Ltd. |
| Client GST | 29AAACI1681G1ZX |
| Client Address | Electronics City, Phase 1, Bengaluru – 560100, Karnataka |
| Sub Total (INR) | 6,48,000 |
| CGST @ 9% (INR) | 58,320 |
| SGST @ 9% (INR) | 58,320 |
| Gross Total (INR) | 7,64,640 |
| TDS @ 2% (INR) | 15,293 |
| Net Payable (INR) | 7,49,347 |
| Payment Status | PAID |
| Bank Name | HDFC Bank Ltd. |
| Account Number | 50200012345678 |
| IFSC Code | HDFC0001234 |

### Line Items (Sheet 2 — 6 items)

| # | Description | SAC Code | Qty | Rate | Amount | GST % |
|---|---|---|---|---|---|---|
| 1 | Custom ERP Module Development | 998314 | 1 | 1,80,000 | 1,80,000 | 18% |
| 2 | Mobile App Development | 998315 | 1 | 2,40,000 | 2,40,000 | 18% |
| 3 | Cloud Infrastructure Setup | 998316 | 1 | 75,000 | 75,000 | 18% |
| 4 | Annual Software Maintenance | 998313 | 1 | 60,000 | 60,000 | 18% |
| 5 | UI/UX Design Services | 998311 | 8 | 8,500 | 68,000 | 18% |
| 6 | Technical Documentation & Training | 998312 | 2 | 12,500 | 25,000 | 18% |

---


## Workflow Structure

    Main Sequence
    ├── Log - Bot Started
    └── Try Catch
        ├── TRY
        │   ├── Read PDF Text → pdfText
        │   ├── Write Text File → invoiceData.txt (debug)
        │   ├── Log - PDF Extracted
        │   ├── Matches × 18 (header field extraction)
        │   ├── Assign × 2 (Vendor Address, Client Address)
        │   ├── Assign × 2 (Vendor Name, Payment Status)
        │   ├── Build Data Table → dtHeader (22 rows × 2 columns)
        │   ├── Add Data Row × 22
        │   ├── Build Line Items Table → dtLineItems (7 columns)
        │   ├── Matches: Extract Line Items → lineItems
        │   ├── For Each currentMatch in lineItems
        │   │   └── Add Data Row → dtLineItems
        │   ├── Write Range Workbook → "Invoice Header" sheet
        │   ├── Write Range Workbook → "Line Items" sheet
        │   ├── Log - Excel Generated
        │   ├── Use Excel File + Invoke VBA → format_invoice.vbs
        │   ├── Write Text File → InvoiceBot_Log.txt
        │   ├── Message Box → "Invoice INV-2024-0087 extracted successfully!"
        │   └── Log - Bot Completed
        ├── CATCH (System.Exception)
        │   ├── Log - Error
        │   ├── Message Box (error details)
        │   └── Write Text File → ErrorLog.txt
        └── FINALLY
            └── Write Text File → execution log

---

## Error Handling

The entire workflow is wrapped in a **Try-Catch-Finally** block:
- **Try**: All extraction and Excel writing logic
- **Catch**: Logs the error, shows error message box, writes error log file
- **Finally**: Always writes execution log regardless of success or failure

---

## How to Run

1. Clone the repo or download the project
2. Open `project.json` in UiPath Studio
3. Ensure `sample_invoice.pdf` is in the project folder
4. Ensure `format_invoice.vbs` is in the project folder
5. Press **F5** or click **Run**

---


