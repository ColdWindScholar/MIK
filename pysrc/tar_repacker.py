import os
import sys
import struct
import tarfile

# Предопределенные словари для перевода UID в Uname и GID в Gname
id_to_name_dict = {
    0: "root",
    1: "daemon",
    2: "bin",
    3: "sys",
    1000: "system",
    1001: "radio",
    1002: "bluetooth",
    1003: "graphics",
    1004: "input",
    1005: "audio",
    1006: "camera",
    1007: "log",
    1008: "compass",
    1009: "mount",
    1010: "wifi",
    1011: "adb",
    1012: "install",
    1013: "media",
    1014: "dhcp",
    1015: "sdcard_rw",
    1016: "vpn",
    1017: "keystore",
    1018: "usb",
    1019: "drm",
    1020: "mdnsr",
    1021: "gps",
    1022: "unused1",
    1023: "media_rw",
    1024: "mtp",
    1025: "unused2",
    1026: "drmrpc",
    1027: "nfc",
    1028: "sdcard_r",
    1029: "clat",
    1030: "loop_radio",
    1031: "media_drm",
    1032: "package_info",
    1033: "sdcard_pics",
    1034: "sdcard_av",
    1035: "sdcard_all",
    1036: "logd",
    1037: "shared_relro",
    1038: "dbus",
    1039: "tlsdate",
    1040: "media_ex",
    1041: "audioserver",
    1042: "metrics_coll",
    1043: "metricsd",
    1044: "webserv",
    1045: "debuggerd",
    1046: "media_codec",
    1047: "cameraserver",
    1048: "firewall",
    1049: "trunks",
    1050: "nvram",
    1051: "dns",
    1052: "dns_tether",
    1053: "webview_zygote",
    1054: "vehicle_network",
    1055: "media_audio",
    1056: "media_video",
    1057: "media_image",
    1058: "tombstoned",
    1059: "media_obb",
    1060: "ese",
    1061: "ota_update",
    1062: "automotive_evs",
    1063: "lowpan",
    1064: "hsm",
    1065: "reserved_disk",
    1066: "statsd",
    1067: "incidentd",
    1068: "secure_element",
    1069: "lmkd",
    1070: "llkd",
    1071: "iorapd",
    1072: "gpu_service",
    1073: "network_stack",
    1074: "gsid",
    1075: "fsverity_cert",
    1076: "credstore",
    1077: "external_storage",
    1078: "ext_data_rw",
    1079: "ext_obb_rw",
    1080: "context_hub",
    1081: "virtualizationservice",
    1082: "artd",
    1083: "uwb",
    1084: "thread_network",
    1085: "diced",
    1086: "dmesgd",
    1087: "jc_weaver",
    1088: "jc_strongbox",
    1089: "jc_identitycred",
    1090: "sdk_sandbox",
    1091: "security_log_writer",
    1092: "prng_seeder",
    1093: "uprobestats",
    1094: "cros_ec",
    1300: "thememan",
    1301: "audit",
    2000: "shell",
    2001: "cache",
    2002: "diag",
    2900: "oem_reserved_start",
    2950: "qcom_diag",
    2951: "rfs",
    2952: "rfs_shared",
    2999: "oem_reserved_end",
    3001: "net_bt_admin",
    3002: "net_bt",
    3003: "inet",
    3004: "net_raw",
    3005: "net_admin",
    3006: "net_bw_stats",
    3007: "net_bw_acct",
    3008: "net_bt_stack",
    3009: "readproc",
    3010: "wakelock",
    3011: "uhid",
    3012: "readtracefs",
    3013: "virtualmachine",
    3014: "rfs_shared_old",
    5000: "oem_reserved_2_start",
    5999: "oem_reserved_2_end",
    6000: "system_reserved_start",
    6499: "system_reserved_end",
    6500: "odm_reserved_start",
    6999: "odm_reserved_end",
    7000: "product_reserved_start",
    7499: "product_reserved_end",
    7500: "system_ext_reserved_start",
    7999: "system_ext_reserved_end",
    9000: "mot_accy",
    9001: "mot_pwric",
    9002: "mot_usb",
    9003: "mot_drm",
    9004: "mot_tcmd",
    9005: "mot_sec_rtc",
    9006: "mot_tombstone",
    9007: "mot_tpapi",
    9008: "mot_secclkd",
    9009: "mot_whisper",
    9010: "mot_caif",
    9011: "mot_dlna",
    9997: "everybody",
    9998: "misc",
    9999: "nobody",
    10000: "app",
    19999: "app_end",
    20000: "cache_gid_start",
    29999: "cache_gid_end",
    30000: "ext_gid_start",
    39999: "ext_gid_end",
    40000: "ext_cache_gid_start",
    49999: "ext_cache_gid_end",
    50000: "shared_gid_start",
    59999: "shared_gid_end",
    65534: "overflowuid",
    90000: "isolated_start",
    99999: "isolated_end",
    100000: "user"
}


def id_to_name(uid):
    return id_to_name_dict.get(uid, str(uid))


# Чтение файла с правами доступа и информацией о символических ссылках
def read_permissions_file(permissions_file):
    permissions = {}
    with open(permissions_file, 'r') as file:
        for line in file:
            # match line.strip().split(";"):
            match line.strip().split():
                case [path, uid, gid, mode, context, capabilities, symlink]:
                    permissions[path] = (int(uid), int(gid), int(mode, 8), context, capabilities, symlink)
                case [path, uid, gid, mode, context, symlink]:
                    permissions[path] = (int(uid), int(gid), int(mode, 8), context, '', symlink)
                case [path, uid, gid, mode, context, capabilities]:
                    permissions[path] = (int(uid), int(gid), int(mode, 8), context, capabilities, '')
                case [path, uid, gid, mode, context]:
                    permissions[path] = (int(uid), int(gid), int(mode, 8), context, '', '')
                case [path, uid, gid, mode]:
                    permissions[path] = (int(uid), int(gid), int(mode, 8), '', '', '')
                case _:
                    print(f"Invalid line: {line.strip()} in file: {permissions_file}")
    return permissions


# Сохранение метаданных в файл даже при отсутствии значений
def save_metadata_to_file(tar, dest_dir, metadata_file):
    # permissions = [[],[]]
    permissions = []
    for member in tar.getmembers():
        name = member.name
        if name[0] == "/":
            name = name[1:]
        uid = member.uid
        gid = member.gid
        mode = oct(member.mode)
        symlink = member.linkname if member.issym() else ""
        capabilities = ''
        context = ''
        if 'RHT.security.selinux' in member.pax_headers:
            context = member.pax_headers.get('RHT.security.selinux')
        if 'SCHILY.xattr.security.capability' in member.pax_headers:
            try:
                data = bytearray(member.pax_headers.get('SCHILY.xattr.security.capability').encode('utf-8'))
            except:
                data = bytearray(member.pax_headers.get('SCHILY.xattr.security.capability').encode('utf-8', 'surrogateescape'))
            capabilities = '' + str(hex(struct.unpack("<5I", data)[1]))
        permissions.append('%s %s %s %s %s %s %s' % (name, uid, gid, mode, context, capabilities, symlink))
    permissions.sort()

    with open(metadata_file, 'a', newline='\n') as file:
        # print('\n'.join(new_permissions), file=file)
        print('\n'.join(permissions), file=file)


# Функция для преобразования hex capabilites в нужный формат
def capabilities_to_pax_header_surrogateescape(capabilities_hex):
    capabilities_int = int(capabilities_hex, 16)
    data = struct.pack("<5I", 0, capabilities_int, 0, 0, 0)
    capability_string = data.decode('utf-8', 'surrogateescape')
    return capability_string


def capabilities_to_pax_header(capabilities_hex):
    capabilities_int = int(capabilities_hex, 16)
    data = struct.pack("<5I", 0, capabilities_int, 0, 0, 0)
    capability_string = data.decode('utf-8')
    return capability_string


# Функция для добавления файлов в архив с учетом символических ссылок и метаданных
def add_file_to_tar(tar, file_path, arcname, permissions):
    arcname = arcname.replace(os.sep, "/")  # иначе ничего не находит
    tarinfo = tar.gettarinfo(file_path, arcname)
    if arcname in permissions:
        # Проверка на наличие символической ссылки в метаданных
        if permissions[arcname][5] != '':  # [5] - это поле с информацией о символической ссылке
            link_target = permissions[arcname][5]
            tarinfo = tarfile.TarInfo(name=arcname)
            tarinfo.type = tarfile.SYMTYPE
            tarinfo.linkname = link_target

        uid, gid, mode, context, capabilities_hex, _ = permissions[arcname]
        tarinfo.uid = uid
        tarinfo.gid = gid
        tarinfo.mode = mode
        tarinfo.uname = id_to_name(uid)
        tarinfo.gname = id_to_name(gid)

        if context or capabilities_hex:
            tarinfo.pax_headers = {}
            if context != '':
                tarinfo.pax_headers['RHT.security.selinux'] = context
            if capabilities_hex != '':
                pax_capability_string = ""
                try:
                    pax_capability_string = capabilities_to_pax_header(capabilities_hex)
                except:
                    pax_capability_string = capabilities_to_pax_header_surrogateescape(capabilities_hex)
                tarinfo.pax_headers['SCHILY.xattr.security.capability'] = pax_capability_string

    if os.path.isdir(file_path):
        tarinfo.type = tarfile.DIRTYPE
        tar.addfile(tarinfo)
    else:
        with open(file_path, 'rb') as f:
            tar.addfile(tarinfo, f)


# Создание архива с правами и символическими ссылками
def create_tar_with_permissions(source_dir, tar_file, permissions):
    with tarfile.open(tar_file, "w") as tar:
        for root, dirs, files in os.walk(source_dir):
            for dir in dirs:
                dir_path = os.path.join(root, dir)
                arcname = os.path.relpath(dir_path, source_dir)
                add_file_to_tar(tar, dir_path, arcname, permissions)
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, source_dir)
                add_file_to_tar(tar, file_path, arcname, permissions)


# Извлечение символических ссылок как пустых файлов при распаковке
def extract_symlink_as_empty_file(tar, member, dest_dir):
    file_path = os.path.join(dest_dir, member.name)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    open(file_path, 'w').close()


# Распаковка архива с сохранением метаданных в файл и извлечением символических ссылок как пустых файлов
def extract_tar_with_permissions(tar_file, dest_dir, metadata_file):
    compression_mode = get_compression_mode_for_extract(tar_file)
    with tarfile.open(tar_file, compression_mode) as tar:
        save_metadata_to_file(tar, dest_dir, metadata_file)
        for member in tar.getmembers():
            if member.path[0] == "/":  # если начинается с слэша
                member.path = os.path.normpath(dest_dir + member.path)
            if member.issym():
                extract_symlink_as_empty_file(tar, member, dest_dir)
            else:
                tar.extract(member, path=dest_dir, filter='fully_trusted')


# Определение режима сжатия при распаковке
def get_compression_mode_for_extract(tar_file):
    if tar_file.endswith(".tar.gz"):
        return "r:gz"
    elif tar_file.endswith(".tar.bz2"):
        return "r:bz2"
    else:
        return "r"


# Функция для проверки сигнатуры tar-файла
def is_tarfile(filepath):
    try:
        with open(filepath, 'rb') as f:
            f.seek(257)  # Перемещаемся к байту 257
            return f.read(5) == b'ustar'
    except Exception as e:
        print(f"Error checking file {filepath}: {e}")
        return False


def main():
    if len(sys.argv) < 2:
        print("Error: No arguments specified. Please specify a file or directory.")
        sys.exit(1)

    source = os.path.realpath(sys.argv[1])
    if os.path.isdir(source):
        # Это директория, значит будем создавать архив
        dest_tar = f"{source}_archive.tar"
        permissions_file = f"{source}_metadata.txt"  # Предположим, что файл с правами рядом с папкой
        permissions_data = read_permissions_file(permissions_file)
        create_tar_with_permissions(source, dest_tar, permissions_data)
        print(f"Archive {dest_tar} successfully created.")

    elif os.path.isfile(source) and is_tarfile(source):
        # Это tar-файл, будем его распаковывать
        dest_dir = source.split('.')[0]
        metadata_file = f"{dest_dir}_metadata.txt"
        extract_tar_with_permissions(source, dest_dir, metadata_file)
        print(f"Archive {source} successfully unpacked in {dest_dir}.")

    else:
        print(f"Error: {source} is neither a directory nor a tarball.")
        sys.exit(1)


if __name__ == "__main__":
    print("Windows tar_repaker created by blackeangel special for 4pda")
    main()
