﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class InObjHelperWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("InObjHelper");
		L.RegFunction("FindInObjGameObject", FindInObjGameObject);
		L.RegFunction("CloseObj", CloseObj);
		L.RegFunction("ActiveObj", ActiveObj);
		L.RegFunction("RegLuaCallBack", RegLuaCallBack);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FindInObjGameObject(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			UnityEngine.GameObject o = InObjHelper.FindInObjGameObject(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CloseObj(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			InObjHelper.CloseObj(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ActiveObj(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			InObjHelper.ActiveObj(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegLuaCallBack(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(InteractiveObj), typeof(LuaInterface.LuaFunction)))
			{
				InteractiveObj arg0 = (InteractiveObj)ToLua.ToObject(L, 1);
				LuaFunction arg1 = ToLua.ToLuaFunction(L, 2);
				InObjHelper.RegLuaCallBack(arg0, arg1);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(string), typeof(LuaInterface.LuaFunction)))
			{
				string arg0 = ToLua.ToString(L, 1);
				LuaFunction arg1 = ToLua.ToLuaFunction(L, 2);
				InObjHelper.RegLuaCallBack(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: InObjHelper.RegLuaCallBack");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}
