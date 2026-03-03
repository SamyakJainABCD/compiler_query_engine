; ModuleID = 'my_code.c'
source_filename = "my_code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @j(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !10 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !15, metadata !DIExpression()), !dbg !16
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 %2, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !19, metadata !DIExpression()), !dbg !20
  store i32 %3, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !21, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata ptr %9, metadata !23, metadata !DIExpression()), !dbg !25
  store i32 0, ptr %9, align 4, !dbg !25
  br label %12, !dbg !26

12:                                               ; preds = %20, %4
  %13 = load i32, ptr %9, align 4, !dbg !27
  %14 = load i32, ptr %5, align 4, !dbg !29
  %15 = icmp slt i32 %13, %14, !dbg !30
  br i1 %15, label %16, label %23, !dbg !31

16:                                               ; preds = %12
  %17 = load i32, ptr %9, align 4, !dbg !32
  %18 = load i32, ptr %9, align 4, !dbg !34
  %19 = add nsw i32 %18, %17, !dbg !34
  store i32 %19, ptr %9, align 4, !dbg !34
  br label %20, !dbg !35

20:                                               ; preds = %16
  %21 = load i32, ptr %9, align 4, !dbg !36
  %22 = add nsw i32 %21, 1, !dbg !36
  store i32 %22, ptr %9, align 4, !dbg !36
  br label %12, !dbg !37, !llvm.loop !38

23:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata ptr %10, metadata !41, metadata !DIExpression()), !dbg !42
  store i32 10, ptr %10, align 4, !dbg !42
  call void @llvm.dbg.declare(metadata ptr %11, metadata !43, metadata !DIExpression()), !dbg !44
  %24 = load i32, ptr %11, align 4, !dbg !45
  ret i32 %24, !dbg !46
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "my_code.c", directory: "/home/samyak/CD", checksumkind: CSK_MD5, checksum: "736be8b805f0c33a211a231ebfc29fb1")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 2}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!10 = distinct !DISubprogram(name: "j", scope: !1, file: !1, line: 1, type: !11, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !13, !13, !13, !13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "r", arg: 1, scope: !10, file: !1, line: 1, type: !13)
!16 = !DILocation(line: 1, column: 11, scope: !10)
!17 = !DILocalVariable(name: "s", arg: 2, scope: !10, file: !1, line: 1, type: !13)
!18 = !DILocation(line: 1, column: 18, scope: !10)
!19 = !DILocalVariable(name: "t", arg: 3, scope: !10, file: !1, line: 1, type: !13)
!20 = !DILocation(line: 1, column: 25, scope: !10)
!21 = !DILocalVariable(name: "u", arg: 4, scope: !10, file: !1, line: 1, type: !13)
!22 = !DILocation(line: 1, column: 32, scope: !10)
!23 = !DILocalVariable(name: "i", scope: !24, file: !1, line: 2, type: !13)
!24 = distinct !DILexicalBlock(scope: !10, file: !1, line: 2, column: 5)
!25 = !DILocation(line: 2, column: 13, scope: !24)
!26 = !DILocation(line: 2, column: 9, scope: !24)
!27 = !DILocation(line: 2, column: 20, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !1, line: 2, column: 5)
!29 = !DILocation(line: 2, column: 24, scope: !28)
!30 = !DILocation(line: 2, column: 22, scope: !28)
!31 = !DILocation(line: 2, column: 5, scope: !24)
!32 = !DILocation(line: 3, column: 14, scope: !33)
!33 = distinct !DILexicalBlock(scope: !28, file: !1, line: 2, column: 32)
!34 = !DILocation(line: 3, column: 11, scope: !33)
!35 = !DILocation(line: 4, column: 5, scope: !33)
!36 = !DILocation(line: 2, column: 28, scope: !28)
!37 = !DILocation(line: 2, column: 5, scope: !28)
!38 = distinct !{!38, !31, !39, !40}
!39 = !DILocation(line: 4, column: 5, scope: !24)
!40 = !{!"llvm.loop.mustprogress"}
!41 = !DILocalVariable(name: "x", scope: !10, file: !1, line: 5, type: !13)
!42 = !DILocation(line: 5, column: 9, scope: !10)
!43 = !DILocalVariable(name: "p", scope: !10, file: !1, line: 6, type: !13)
!44 = !DILocation(line: 6, column: 9, scope: !10)
!45 = !DILocation(line: 7, column: 12, scope: !10)
!46 = !DILocation(line: 7, column: 5, scope: !10)
