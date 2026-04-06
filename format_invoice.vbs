Sub FormatInvoice()
    Dim wb As Workbook
    Dim ws1 As Worksheet, ws2 As Worksheet
    Set wb = ThisWorkbook
    Set ws1 = wb.Sheets("Invoice Header")
    Set ws2 = wb.Sheets("Line Items")

    ' ===== INVOICE HEADER SHEET =====
    ws1.Rows("1:4").Insert Shift:=xlDown

    ' Row 1 - Title
    ws1.Range("A1:B1").Merge
    ws1.Range("A1").Value = "INVOICE EXTRACTION " & ChrW(8212) & " HEADER DATA"
    With ws1.Range("A1")
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Font.Size = 14
        .Interior.Color = RGB(31, 56, 100)
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
    End With
    ws1.Rows(1).RowHeight = 28

    ' Row 2 - Subtitle
    ws1.Range("A2:B2").Merge
    ws1.Range("A2").Value = "Extracted by UiPath Bot | Source: sample_invoice.pdf"
    With ws1.Range("A2")
        .Font.Italic = True
        .Font.Color = RGB(128, 128, 128)
        .Font.Size = 10
        .Interior.Color = RGB(240, 240, 240)
        .HorizontalAlignment = xlCenter
    End With
    ws1.Rows(2).RowHeight = 18

    ' Row 3 - Spacer
    ws1.Rows(3).RowHeight = 8

    ' Row 4 - Column Headers
    ws1.Range("A4").Value = "Field"
    ws1.Range("B4").Value = "Extracted Value"
    With ws1.Range("A4:B4")
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(31, 56, 100)
        .HorizontalAlignment = xlCenter
    End With
    ws1.Rows(4).RowHeight = 22

    ' Rows 5-26 - Alternating colours (only columns A:B)
    Dim i As Integer
    For i = 5 To 26
        If (i Mod 2) = 1 Then
            ws1.Range("A" & i & ":B" & i).Interior.Color = RGB(214, 228, 240)
        Else
            ws1.Range("A" & i & ":B" & i).Interior.Color = RGB(255, 255, 255)
        End If
        ws1.Cells(i, 1).Font.Bold = True
        ws1.Rows(i).RowHeight = 18
    Next i

    ' Column widths
    ws1.Columns("A").ColumnWidth = 25
    ws1.Columns("B").ColumnWidth = 42

    ' ===== LINE ITEMS SHEET =====
    ws2.Rows("1:4").Insert Shift:=xlDown

    ' Row 1 - Title
    Dim invNo As String
    invNo = ws1.Range("B5").Value
    ws2.Range("A1:G1").Merge
    ws2.Range("A1").Value = "INVOICE LINE ITEMS " & ChrW(8212) & " " & invNo
    With ws2.Range("A1")
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Font.Size = 14
        .Interior.Color = RGB(31, 56, 100)
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
    End With
    ws2.Rows(1).RowHeight = 28

    ' Row 2 - Subtitle
    ws2.Range("A2:G2").Merge
    ws2.Range("A2").Value = "Extracted by UiPath Bot | Source: sample_invoice.pdf"
    With ws2.Range("A2")
        .Font.Italic = True
        .Font.Color = RGB(128, 128, 128)
        .Font.Size = 10
        .Interior.Color = RGB(240, 240, 240)
        .HorizontalAlignment = xlCenter
    End With
    ws2.Rows(2).RowHeight = 18

    ' Row 3 - Spacer
    ws2.Rows(3).RowHeight = 8

    ' Row 4 - Dark Blue Column Headers
    Dim hdrs As Variant
    hdrs = Array("#", "Description", "SAC Code", "Qty", "Rate (INR)", "Amount (INR)", "GST %")
    Dim j As Integer
    For j = 0 To 6
        ws2.Cells(4, j + 1).Value = hdrs(j)
        With ws2.Cells(4, j + 1)
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(31, 56, 100)
            .HorizontalAlignment = xlCenter
        End With
    Next j
    ws2.Rows(4).RowHeight = 22

    ' Data rows - alternating colours (only columns A:G)
    Dim lastRow As Integer
    lastRow = ws2.Cells(ws2.Rows.Count, 1).End(xlUp).Row
    For i = 5 To lastRow
        If (i Mod 2) = 1 Then
            ws2.Range("A" & i & ":G" & i).Interior.Color = RGB(214, 228, 240)
        Else
            ws2.Range("A" & i & ":G" & i).Interior.Color = RGB(255, 255, 255)
        End If
        ws2.Rows(i).RowHeight = 18
    Next i

    ' TOTAL row
    Dim totalRow As Integer
    totalRow = lastRow + 1
    ws2.Range("A" & totalRow & ":E" & totalRow).Merge
    ws2.Cells(totalRow, 1).Value = "TOTAL"
    ws2.Cells(totalRow, 1).HorizontalAlignment = xlRight
    With ws2.Range("A" & totalRow & ":G" & totalRow)
        .Interior.Color = RGB(31, 56, 100)
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
    End With
    ws2.Rows(totalRow).RowHeight = 20

    ' Calculate TOTAL manually (amounts stored as text with commas)
    Dim totalAmt As Double
    totalAmt = 0
    Dim k As Integer
    For k = 5 To lastRow
        Dim cellVal As String
        cellVal = Replace(ws2.Cells(k, 6).Value, ",", "")
        If IsNumeric(cellVal) Then
            totalAmt = totalAmt + CDbl(cellVal)
        End If
    Next k
    ws2.Cells(totalRow, 6).Value = totalAmt
    ws2.Cells(totalRow, 6).NumberFormat = "#,##0"
    ws2.Cells(totalRow, 6).Font.Bold = True
    ws2.Cells(totalRow, 6).Font.Color = RGB(255, 255, 255)
    ws2.Cells(totalRow, 6).HorizontalAlignment = xlRight

    ' Column widths
    ws2.Columns("A").ColumnWidth = 5
    ws2.Columns("B").ColumnWidth = 45
    ws2.Columns("C").ColumnWidth = 12
    ws2.Columns("D").ColumnWidth = 6
    ws2.Columns("E").ColumnWidth = 14
    ws2.Columns("F").ColumnWidth = 14
    ws2.Columns("G").ColumnWidth = 8

    wb.Save
End Sub
