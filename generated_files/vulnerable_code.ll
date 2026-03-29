; ModuleID = 'vulnerable_code.c'
source_filename = "vulnerable_code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [9 x i8] c"User: %s\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [3 x i8] c"%s\00", align 1, !dbg !12
@.str.3 = private unnamed_addr constant [10 x i8] c"Data: %s\0A\00", align 1, !dbg !17
@.str.4 = private unnamed_addr constant [10 x i8] c"Name: %s\0A\00", align 1, !dbg !22
@.str.5 = private unnamed_addr constant [7 x i8] c"Hello \00", align 1, !dbg !24

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @copy_name(ptr noundef %0) #0 !dbg !39 {
  %2 = alloca ptr, align 8
  %3 = alloca [10 x i8], align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !44, metadata !DIExpression()), !dbg !45
  call void @llvm.dbg.declare(metadata ptr %3, metadata !46, metadata !DIExpression()), !dbg !47
  %4 = getelementptr inbounds [10 x i8], ptr %3, i64 0, i64 0, !dbg !48
  %5 = load ptr, ptr %2, align 8, !dbg !49
  %6 = call ptr @strcpy(ptr noundef %4, ptr noundef %5) #4, !dbg !50
  %7 = getelementptr inbounds [10 x i8], ptr %3, i64 0, i64 0, !dbg !51
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %7), !dbg !52
  ret void, !dbg !53
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare ptr @strcpy(ptr noundef, ptr noundef) #2

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @format_string(ptr noundef %0) #0 !dbg !54 {
  %2 = alloca ptr, align 8
  %3 = alloca [20 x i8], align 16
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata ptr %3, metadata !57, metadata !DIExpression()), !dbg !61
  %4 = getelementptr inbounds [20 x i8], ptr %3, i64 0, i64 0, !dbg !62
  %5 = load ptr, ptr %2, align 8, !dbg !63
  %6 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %4, ptr noundef @.str.1, ptr noundef %5) #4, !dbg !64
  %7 = getelementptr inbounds [20 x i8], ptr %3, i64 0, i64 0, !dbg !65
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %7), !dbg !66
  ret void, !dbg !67
}

; Function Attrs: nounwind
declare i32 @sprintf(ptr noundef, ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @read_from_file(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  %3 = alloca [16 x i8], align 16
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !129, metadata !DIExpression()), !dbg !130
  call void @llvm.dbg.declare(metadata ptr %3, metadata !131, metadata !DIExpression()), !dbg !135
  %4 = load ptr, ptr %2, align 8, !dbg !136
  %5 = getelementptr inbounds [16 x i8], ptr %3, i64 0, i64 0, !dbg !137
  %6 = call i32 (ptr, ptr, ...) @__isoc99_fscanf(ptr noundef %4, ptr noundef @.str.2, ptr noundef %5), !dbg !138
  %7 = getelementptr inbounds [16 x i8], ptr %3, i64 0, i64 0, !dbg !139
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, ptr noundef %7), !dbg !140
  ret void, !dbg !141
}

declare i32 @__isoc99_fscanf(ptr noundef, ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @process_data() #0 !dbg !142 {
  %1 = alloca [15 x i8], align 1
  call void @llvm.dbg.declare(metadata ptr %1, metadata !145, metadata !DIExpression()), !dbg !149
  %2 = getelementptr inbounds [15 x i8], ptr %1, i64 0, i64 0, !dbg !150
  %3 = call i32 (ptr, ...) @__isoc99_scanf(ptr noundef @.str.2, ptr noundef %2), !dbg !151
  %4 = getelementptr inbounds [15 x i8], ptr %1, i64 0, i64 0, !dbg !152
  %5 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef %4), !dbg !153
  ret void, !dbg !154
}

declare i32 @__isoc99_scanf(ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @append_string(ptr noundef %0) #0 !dbg !155 {
  %2 = alloca ptr, align 8
  %3 = alloca [32 x i8], align 16
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !156, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.declare(metadata ptr %3, metadata !158, metadata !DIExpression()), !dbg !162
  %4 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0, !dbg !163
  %5 = call ptr @strcpy(ptr noundef %4, ptr noundef @.str.5) #4, !dbg !164
  %6 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0, !dbg !165
  %7 = load ptr, ptr %2, align 8, !dbg !166
  %8 = call ptr @strcat(ptr noundef %6, ptr noundef %7) #4, !dbg !167
  %9 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0, !dbg !168
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %9), !dbg !169
  ret void, !dbg !170
}

; Function Attrs: nounwind
declare ptr @strcat(ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!29}
!llvm.module.flags = !{!31, !32, !33, !34, !35, !36, !37}
!llvm.ident = !{!38}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 8, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "vulnerable_code.c", directory: "/home/samyak/CD", checksumkind: CSK_MD5, checksum: "9c91275605ca619a3d36f81320760757")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 4)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 9)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 21, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 24, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 3)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !2, line: 22, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 10)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !2, line: 29, type: !19, isLocal: true, isDefinition: true)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !2, line: 35, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 56, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 7)
!29 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !30, splitDebugInlining: false, nameTableKind: None)
!30 = !{!0, !7, !12, !17, !22, !24}
!31 = !{i32 7, !"Dwarf Version", i32 5}
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 1, !"wchar_size", i32 4}
!34 = !{i32 8, !"PIC Level", i32 2}
!35 = !{i32 7, !"PIE Level", i32 2}
!36 = !{i32 7, !"uwtable", i32 2}
!37 = !{i32 7, !"frame-pointer", i32 2}
!38 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!39 = distinct !DISubprogram(name: "copy_name", scope: !2, file: !2, line: 5, type: !40, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !43)
!40 = !DISubroutineType(types: !41)
!41 = !{null, !42}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!43 = !{}
!44 = !DILocalVariable(name: "dest", arg: 1, scope: !39, file: !2, line: 5, type: !42)
!45 = !DILocation(line: 5, column: 22, scope: !39)
!46 = !DILocalVariable(name: "buffer", scope: !39, file: !2, line: 6, type: !19)
!47 = !DILocation(line: 6, column: 10, scope: !39)
!48 = !DILocation(line: 7, column: 12, scope: !39)
!49 = !DILocation(line: 7, column: 20, scope: !39)
!50 = !DILocation(line: 7, column: 5, scope: !39)
!51 = !DILocation(line: 8, column: 20, scope: !39)
!52 = !DILocation(line: 8, column: 5, scope: !39)
!53 = !DILocation(line: 9, column: 1, scope: !39)
!54 = distinct !DISubprogram(name: "format_string", scope: !2, file: !2, line: 12, type: !40, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !43)
!55 = !DILocalVariable(name: "input", arg: 1, scope: !54, file: !2, line: 12, type: !42)
!56 = !DILocation(line: 12, column: 26, scope: !54)
!57 = !DILocalVariable(name: "result", scope: !54, file: !2, line: 13, type: !58)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 160, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 20)
!61 = !DILocation(line: 13, column: 10, scope: !54)
!62 = !DILocation(line: 14, column: 13, scope: !54)
!63 = !DILocation(line: 14, column: 33, scope: !54)
!64 = !DILocation(line: 14, column: 5, scope: !54)
!65 = !DILocation(line: 15, column: 20, scope: !54)
!66 = !DILocation(line: 15, column: 5, scope: !54)
!67 = !DILocation(line: 16, column: 1, scope: !54)
!68 = distinct !DISubprogram(name: "read_from_file", scope: !2, file: !2, line: 19, type: !69, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !43)
!69 = !DISubroutineType(types: !70)
!70 = !{null, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !73, line: 7, baseType: !74)
!73 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !75, line: 49, size: 1728, elements: !76)
!75 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "7a6d4a00a37ee6b9a40cd04bd01f5d00")
!76 = !{!77, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !93, !95, !96, !97, !101, !103, !105, !109, !112, !114, !117, !120, !121, !123, !127, !128}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !74, file: !75, line: 51, baseType: !78, size: 32)
!78 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !74, file: !75, line: 54, baseType: !42, size: 64, offset: 64)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !74, file: !75, line: 55, baseType: !42, size: 64, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !74, file: !75, line: 56, baseType: !42, size: 64, offset: 192)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !74, file: !75, line: 57, baseType: !42, size: 64, offset: 256)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !74, file: !75, line: 58, baseType: !42, size: 64, offset: 320)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !74, file: !75, line: 59, baseType: !42, size: 64, offset: 384)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !74, file: !75, line: 60, baseType: !42, size: 64, offset: 448)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !74, file: !75, line: 61, baseType: !42, size: 64, offset: 512)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !74, file: !75, line: 64, baseType: !42, size: 64, offset: 576)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !74, file: !75, line: 65, baseType: !42, size: 64, offset: 640)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !74, file: !75, line: 66, baseType: !42, size: 64, offset: 704)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !74, file: !75, line: 68, baseType: !91, size: 64, offset: 768)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !75, line: 36, flags: DIFlagFwdDecl)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !74, file: !75, line: 70, baseType: !94, size: 64, offset: 832)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !74, file: !75, line: 72, baseType: !78, size: 32, offset: 896)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !74, file: !75, line: 73, baseType: !78, size: 32, offset: 928)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !74, file: !75, line: 74, baseType: !98, size: 64, offset: 960)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !99, line: 152, baseType: !100)
!99 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
!100 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !74, file: !75, line: 77, baseType: !102, size: 16, offset: 1024)
!102 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !74, file: !75, line: 78, baseType: !104, size: 8, offset: 1040)
!104 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !74, file: !75, line: 79, baseType: !106, size: 8, offset: 1048)
!106 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 8, elements: !107)
!107 = !{!108}
!108 = !DISubrange(count: 1)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !74, file: !75, line: 81, baseType: !110, size: 64, offset: 1088)
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !75, line: 43, baseType: null)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !74, file: !75, line: 89, baseType: !113, size: 64, offset: 1152)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !99, line: 153, baseType: !100)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !74, file: !75, line: 91, baseType: !115, size: 64, offset: 1216)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !75, line: 37, flags: DIFlagFwdDecl)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !74, file: !75, line: 92, baseType: !118, size: 64, offset: 1280)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !75, line: 38, flags: DIFlagFwdDecl)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !74, file: !75, line: 93, baseType: !94, size: 64, offset: 1344)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !74, file: !75, line: 94, baseType: !122, size: 64, offset: 1408)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !74, file: !75, line: 95, baseType: !124, size: 64, offset: 1472)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !125, line: 18, baseType: !126)
!125 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!126 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !74, file: !75, line: 96, baseType: !78, size: 32, offset: 1536)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !74, file: !75, line: 98, baseType: !58, size: 160, offset: 1568)
!129 = !DILocalVariable(name: "fp", arg: 1, scope: !68, file: !2, line: 19, type: !71)
!130 = !DILocation(line: 19, column: 27, scope: !68)
!131 = !DILocalVariable(name: "buffer", scope: !68, file: !2, line: 20, type: !132)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !133)
!133 = !{!134}
!134 = !DISubrange(count: 16)
!135 = !DILocation(line: 20, column: 10, scope: !68)
!136 = !DILocation(line: 21, column: 12, scope: !68)
!137 = !DILocation(line: 21, column: 22, scope: !68)
!138 = !DILocation(line: 21, column: 5, scope: !68)
!139 = !DILocation(line: 22, column: 26, scope: !68)
!140 = !DILocation(line: 22, column: 5, scope: !68)
!141 = !DILocation(line: 23, column: 1, scope: !68)
!142 = distinct !DISubprogram(name: "process_data", scope: !2, file: !2, line: 26, type: !143, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !43)
!143 = !DISubroutineType(types: !144)
!144 = !{null}
!145 = !DILocalVariable(name: "name", scope: !142, file: !2, line: 27, type: !146)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !147)
!147 = !{!148}
!148 = !DISubrange(count: 15)
!149 = !DILocation(line: 27, column: 10, scope: !142)
!150 = !DILocation(line: 28, column: 17, scope: !142)
!151 = !DILocation(line: 28, column: 5, scope: !142)
!152 = !DILocation(line: 29, column: 26, scope: !142)
!153 = !DILocation(line: 29, column: 5, scope: !142)
!154 = !DILocation(line: 30, column: 1, scope: !142)
!155 = distinct !DISubprogram(name: "append_string", scope: !2, file: !2, line: 33, type: !40, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !43)
!156 = !DILocalVariable(name: "user_data", arg: 1, scope: !155, file: !2, line: 33, type: !42)
!157 = !DILocation(line: 33, column: 26, scope: !155)
!158 = !DILocalVariable(name: "buffer", scope: !155, file: !2, line: 34, type: !159)
!159 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 256, elements: !160)
!160 = !{!161}
!161 = !DISubrange(count: 32)
!162 = !DILocation(line: 34, column: 10, scope: !155)
!163 = !DILocation(line: 35, column: 12, scope: !155)
!164 = !DILocation(line: 35, column: 5, scope: !155)
!165 = !DILocation(line: 36, column: 12, scope: !155)
!166 = !DILocation(line: 36, column: 20, scope: !155)
!167 = !DILocation(line: 36, column: 5, scope: !155)
!168 = !DILocation(line: 37, column: 20, scope: !155)
!169 = !DILocation(line: 37, column: 5, scope: !155)
!170 = !DILocation(line: 38, column: 1, scope: !155)
