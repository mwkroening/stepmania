#ifndef NOTEFIELD_POSITIONING_H
#define NOTEFIELD_POSITIONING_H

#include "PlayerNumber.h"
#include "Style.h"
#include "Command.h"

class IniFile;
struct XNode;

struct NoteFieldMode
{
	NoteFieldMode();
	bool MatchesCurrentGame() const;
	void Load(const XNode* pNode, int pn = -1);

	void BeginDrawTrack(int tn);
	void EndDrawTrack(int tn);

	/* Visual name. */
	CString m_Name;

	/* Unique ID from the INI. */
	CString m_Id;

	float m_fPositionTrackX[MAX_NOTE_TRACKS];
	
	float m_fFirstPixelToDrawScale, m_fLastPixelToDrawScale;

	Commands m_JudgmentCmd, m_ComboCmd, m_AttackDisplayCmd;
};

class NoteFieldPositioning
{
public:
	NoteFieldPositioning(CString fn);
	void Load(PlayerNumber pn);

	void GetNamesForCurrentGame(vector<CString> &IDs);
	bool IsValidModeForCurrentStyle(CString mode) const;
	bool IsValidModeForAnyStyle(CString mode) const;

private:
	CString m_Filename;
	vector<NoteFieldMode> Modes;
	int GetID(const CString &name) const;
};

extern NoteFieldMode g_NoteFieldMode[NUM_PLAYERS];

#endif

/*
 * (c) 2001-2004 Chris Danford, Glenn Maynard
 * All rights reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, provided that the above
 * copyright notice(s) and this permission notice appear in all copies of
 * the Software and that both the above copyright notice(s) and this
 * permission notice appear in supporting documentation.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
 * THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
 * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
 * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
 * OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */
