import modules.cfg_extractor as cfg_extractor
import modules.semantic_logger as semantic_logger
import modules.ir_parser as ir_parser
import modules.export_ast as export_ast
import modules.create_ir as create_ir
import modules.semantic_logger as semantic_logger
import json
import os

c_path = 'my_code.c'
output_dir = "generated_files"

ast_output_path = os.path.join(output_dir, "ast_export.json")
export_ast.export_ast_to_json(c_path, ast_output_path)

ir_name = c_path.rsplit('.', 1)[0] + '.ll'
ir_path = os.path.join(output_dir, ir_name)

create_ir.generate_llvm_ir(c_path, ir_path)

ir_output_path = os.path.join(output_dir, "ir_export.json")
ir_parser.export_ir_to_json(ir_path, ir_output_path)

cfg_ouput_path = os.path.join(output_dir, "cfg_export.json")
extractor = cfg_extractor.CFGExtractor(ir_path, output_path=cfg_ouput_path)

cfg_results = extractor.extract_cfg()

sem_log_output_path = os.path.join(output_dir, "semantic_metadata.log")
semantic_logger.generate_semantic_logs(cfg_results, sem_log_output_path)