; ModuleID = 'unsafe_access.c'
source_filename = "unsafe_access.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global ptr, align 8
@.str = private unnamed_addr constant [49 x i8] c"Error: Index 10 out of bounds (array size: %zu)\0A\00", align 1, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @unsafe_access(ptr noundef %0, i64 noundef %1) #0 !dbg !17 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !26, metadata !DIExpression()), !dbg !27
  store i64 %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !28, metadata !DIExpression()), !dbg !29
  %6 = load i64, ptr %5, align 8, !dbg !30
  %7 = icmp uge i64 10, %6, !dbg !32
  br i1 %7, label %8, label %12, !dbg !33

8:                                                ; preds = %2
  %9 = load ptr, ptr @stderr, align 8, !dbg !34
  %10 = load i64, ptr %5, align 8, !dbg !36
  %11 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %9, ptr noundef @.str, i64 noundef %10), !dbg !37
  store i32 -1, ptr %3, align 4, !dbg !38
  br label %15, !dbg !38

12:                                               ; preds = %2
  %13 = load ptr, ptr %4, align 8, !dbg !39
  %14 = getelementptr inbounds i32, ptr %13, i64 10, !dbg !39
  store i32 1, ptr %14, align 4, !dbg !40
  store i32 0, ptr %3, align 4, !dbg !41
  br label %15, !dbg !41

15:                                               ; preds = %12, %8
  %16 = load i32, ptr %3, align 4, !dbg !42
  ret i32 %16, !dbg !42
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 7, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "unsafe_access.c", directory: "/home/samyak/CD", checksumkind: CSK_MD5, checksum: "aab70302aa1a253a0606a2668f6c4cd1")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 392, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 49)
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !8, splitDebugInlining: false, nameTableKind: None)
!8 = !{!0}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!17 = distinct !DISubprogram(name: "unsafe_access", scope: !2, file: !2, line: 4, type: !18, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !25)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !21, !22}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !23, line: 18, baseType: !24)
!23 = !DIFile(filename: "/usr/lib/llvm-18/lib/clang/18/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!24 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!25 = !{}
!26 = !DILocalVariable(name: "arr", arg: 1, scope: !17, file: !2, line: 4, type: !21)
!27 = !DILocation(line: 4, column: 24, scope: !17)
!28 = !DILocalVariable(name: "arr_size", arg: 2, scope: !17, file: !2, line: 4, type: !22)
!29 = !DILocation(line: 4, column: 36, scope: !17)
!30 = !DILocation(line: 6, column: 15, scope: !31)
!31 = distinct !DILexicalBlock(scope: !17, file: !2, line: 6, column: 9)
!32 = !DILocation(line: 6, column: 12, scope: !31)
!33 = !DILocation(line: 6, column: 9, scope: !17)
!34 = !DILocation(line: 7, column: 17, scope: !35)
!35 = distinct !DILexicalBlock(scope: !31, file: !2, line: 6, column: 25)
!36 = !DILocation(line: 7, column: 78, scope: !35)
!37 = !DILocation(line: 7, column: 9, scope: !35)
!38 = !DILocation(line: 8, column: 9, scope: !35)
!39 = !DILocation(line: 10, column: 5, scope: !17)
!40 = !DILocation(line: 10, column: 13, scope: !17)
!41 = !DILocation(line: 11, column: 5, scope: !17)
!42 = !DILocation(line: 12, column: 1, scope: !17)
