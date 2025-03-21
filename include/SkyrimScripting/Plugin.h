#pragma once

#include <RE/Skyrim.h>
#include <SKSE/SKSE.h>
#include <SKSEPluginInfo.h>
#include <SkyrimScripting/Entrypoint.h>
#include <SkyrimScripting/Logging.h>
#include <SkyrimScripting/SKSE_Messages.h>

_SKSEPlugin_Entrypoint_PreInit_HighPriority_(_SkyrimScripting_Plugin_InitializeLogger_) {
    SkyrimScripting::Logging::InitializeLogger(SKSEPluginInfo::GetPluginName());
    SKSE::log::trace("Logger initialized");
    return true;
}

_SKSEPlugin_Entrypoint_PostInit_HighPriority_(_SkyrimScripting_Plugin_ListenForMessages_) {
    SkyrimScripting::SKSE_Messages::ListenForSkseMessages();
    SKSE::log::trace("Listening for SKSE messages");
    return true;
}
