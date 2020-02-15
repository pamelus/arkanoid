program arkanoid;
uses graph, crt;

var
	xBall, yBall	: integer;
    xFlip, yFlip	: integer;
	xDirection		: integer;
    yDirection		: integer;
    zdarzenia		: integer;

    koniec			: boolean;
    win				: boolean;


    xPole			: array [0..59] of integer;
    yPole			: array [0..59] of integer;
    cPole			: array [0..59] of integer;

const
	cxBall = 3;
    cyBall = 3;

    cxPole = 30;
    cyPole = 10;

    cxFlip = 60;
    cyFlip = 10;

    cxScreen = 640;
    cyScreen = 480;

    FlipStep = 7;
    FlipTime = 4;

procedure Inicjuj;
var
	card, mode	: integer;
	i 			: integer;
    offset		: integer;
begin
	DetectGraph(card, mode);
    InitGraph(card, mode, 'C:\TP\BGI');

    offset := (cxScreen div 2) - ((15 * (cxPole + 2)) div 2);

    for i := 0 to 59 do
    begin
    	xPole[i] := (i mod 15) * (cxPole + 2) + offset;
        yPole[i] := (i div 15) * (cyPole + 2) + 70;
		cPole[i] := 11;
    end;

    xDirection := 1;
    yDirection := -1;

    xBall := cxScreen div 2;
    yBall := cyScreen - 71 - cyBall;

    xFlip := cxScreen div 2 - cxFlip div 2;
    yFlip := cyScreen - 70;

    koniec := false;
    win := false;

    SetColor(3);
    Rectangle(49, 49, cxScreen - 49, cyScreen - 49);
end;

procedure Zakoncz;
var
	text	: string;
begin
	SetColor(15);

    if win then text := 'Zwyciestwo!!! Nacisnij enter aby wyjsc.'
    else text := 'Porazka!!! Nacisnij enter aby wyjsc.';

	OutTextXY(cxScreen div 2 - TextWidth(text) div 2, cyScreen div 2 - TextHeight(text) div 2 , text);
    repeat until readkey = #13;
    CloseGraph;
end;

procedure ShowBall;
begin
	SetColor(0);
    Rectangle(xBall, yBall, xBall + cxBall, yBall + cyBall);
    xBall := xBall + xDirection;
    yBall := yBall + yDirection;

    SetColor(13);
    Rectangle(xBall, yBall, xBall + cxBall, yBall + cyBall);
end;

procedure ShowPole;
var
	i		: integer;
begin
	for i := 0 to 59 do
    begin
    	SetColor(cPole[i]);
        Rectangle(xPole[i], yPole[i], xPole[i] + cxPole, yPole[i] + cypole);
    end;

end;

procedure ShowFlipper;
begin
	SetColor(10);
    Rectangle(xFlip, yFlip, xFlip + cxFlip, yFlip + cyFlip);
end;

procedure MoveFlipper(dir : integer);
begin
	SetColor(0);
    Rectangle(xFlip, yFlip, xFlip + cxFlip, yFlip + cyFlip);

	xFlip := xFlip + FlipStep * dir;

    if(xFlip <= 50) then xFlip := 51;
    if(xFlip + cxFlip >= cxScreen - 50) then xFlip := cxScreen - 51 - cxFlip;

end;

procedure ShowPunkty;
var pts		: string;
begin
	SetColor(0);
    str((zdarzenia - 1) * 100, pts);
    OutTextXY(50 + TextWidth('Zdobyte punkty: '), cyScreen - 45, pts);

	SetColor(15);
    str(zdarzenia * 100, pts);
    pts := 'Zdobyte punkty: ' + pts;
    OutTextXY(50, cyScreen - 45, pts);
end;

procedure DetectPole;
var
	i		: integer;
begin
	if yBall < 4 * (cyPole + 2) + 71 then
	for i := 0 to 59 do
    begin
    	if cPole[i] > 0 then
        begin
	    	if (xBall >= xPole[i] - 1) and (xBall + cxBall <= xPole[i] + cxPole + 1)
			and (yBall <= yPole[i] + cyPole + 1) and (yBall + cyBall >= yPole[i] - 1) then
	        begin
            	Sound(3000);
				zdarzenia := zdarzenia + 1;

                if zdarzenia = 30 then xDirection := xDirection * 2;

	        	cPole[i] := 0;
	            if(yBall = yPole[i] + cyPole + 1) or (yBall + cyBall = yPole[i] - 1) then yDirection := yDirection * -1;
	            if(xBall + cxBall = xPole[i] - 1) or (xBall = xPole[i] + cxPole + 1) then xDirection := xDirection * -1;

                ShowPunkty;
	        end;
        end;
    end;
end;

procedure DetectWall;
begin
	if (xBall <= 50) or (xBall + cxBall >= cxScreen - 50) then
    begin
    	Sound(2000);
		xDirection := xDirection * -1;
    end;

    if (yBall <= 50) then
	begin
    	Sound(1000);
		yDirection := yDirection * -1;
    end;

    if yBall + cyBall >= cyScreen - 50 then
    begin
    	koniec := true;
        win := false;
        Sound(100);
    end;
end;

procedure DetectFlipper;
var
	key			: char;
begin
	if (xBall + cxBall >= xFlip - 1) and (xBall <= xFlip + cxFlip + 1) and (yBall + cxBall = yFlip + 1) then
    begin
    	Sound(2000);
	    yDirection := yDirection * -1;
    end;
end;

procedure DetectKlawisze;
var
	key			: char;
begin
	if keypressed then
        begin
			key := readkey;

            if key = #27 then
			begin
            	koniec := true;
                win := false;
			end;

            if key = #75 then
            begin
            	MoveFlipper(-1);
            end;

            if key = #77 then
            begin
            	MoveFlipper(1);
            end;
        end;
end;

procedure Start;
var
	text		: string;
    i			: integer;
    j			: integer;
begin
    j := 3;
    text := '';

	for i := 0 to 3 do
    begin
		SetColor(0);
        OutTextXY(cxScreen div 2 - TextWidth(text) div 2, cyScreen div 2 - TextHeight(text) div 2, text);

        SetColor(15);
        str(j, text);
        text := 'Przygotuj sie... ' + text;
        OutTextXY(cxScreen div 2 - TextWidth(text) div 2, cyScreen div 2 - TextHeight(text) div 2, text);
        Delay(700);
        j := j - 1;
    end;

    SetColor(0);
    OutTextXY(cxScreen div 2 - TextWidth(text) div 2, cyScreen div 2 - TextHeight(text) div 2, text);

end;

procedure Info;
var
	text1		: string;
    text2		: string;
    text3		: string;
begin
	SetColor(15);
    text1 := 'Copyright (c) by Xamax Software Patryk Kozlowski';
    text2 := 'All rights reserved.';
    text3 := 'EINSTEIN NA PREZYDENTA!!!';

    OutTextXY(cxScreen div 2 - TextWidth(text1) div 2, cyScreen div 2 - TextHeight(text1) div 2 - 20, text1);
	Delay(1000);
    OutTextXY(cxScreen div 2 - TextWidth(text2) div 2, cyScreen div 2 + TextHeight(text2) div 2 + 20, text2);
    Delay(2000);
    OutTextXY(cxScreen div 2 - TextWidth(text3) div 2, cyScreen div 2 - TextHeight(text3) div 2 + 5, text3);
    Delay(3000);

    SetColor(0);
    OutTextXY(cxScreen div 2 - TextWidth(text1) div 2, cyScreen div 2 - TextHeight(text1) div 2 - 20, text1);
    OutTextXY(cxScreen div 2 - TextWidth(text2) div 2, cyScreen div 2 + TextHeight(text2) div 2 + 20, text2);
    OutTextXY(cxScreen div 2 - TextWidth(text3) div 2, cyScreen div 2 - TextHeight(text3) div 2 + 5, text3);
end;

begin
	Inicjuj;
    Info;
    ShowFlipper;
    ShowBall;
    ShowPole;
    ShowPunkty;
    Start;
    repeat
        DetectPole;
        DetectWall;
        DetectFlipper;

        ShowPole;
        ShowFlipper;
		ShowBall;

        DetectKlawisze;
        ShowFlipper;

        Delay(FlipTime);
		NoSound;

        if zdarzenia = 60 then
        begin
        	koniec := true;
            win := true;
        end;

    until koniec;
    Zakoncz;
end.
