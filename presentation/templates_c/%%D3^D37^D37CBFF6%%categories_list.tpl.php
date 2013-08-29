<?php /* Smarty version 2.6.27, created on 2013-08-29 18:15:06
         compiled from categories_list.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'load_categories_list', 'categories_list.tpl', 2, false),array('modifier', 'prepare_link', 'categories_list.tpl', 12, false),)), $this); ?>
<?php echo smarty_function_load_categories_list(array('assign' => 'categories_list'), $this);?>

<div class="left_box" id="categories_box">
	<p>Choose a Category</p>
	<ol>
		<?php unset($this->_sections['i']);
$this->_sections['i']['name'] = 'i';
$this->_sections['i']['loop'] = is_array($_loop=$this->_tpl_vars['categories_list']->mCategories) ? count($_loop) : max(0, (int)$_loop); unset($_loop);
$this->_sections['i']['show'] = true;
$this->_sections['i']['max'] = $this->_sections['i']['loop'];
$this->_sections['i']['step'] = 1;
$this->_sections['i']['start'] = $this->_sections['i']['step'] > 0 ? 0 : $this->_sections['i']['loop']-1;
if ($this->_sections['i']['show']) {
    $this->_sections['i']['total'] = $this->_sections['i']['loop'];
    if ($this->_sections['i']['total'] == 0)
        $this->_sections['i']['show'] = false;
} else
    $this->_sections['i']['total'] = 0;
if ($this->_sections['i']['show']):

            for ($this->_sections['i']['index'] = $this->_sections['i']['start'], $this->_sections['i']['iteration'] = 1;
                 $this->_sections['i']['iteration'] <= $this->_sections['i']['total'];
                 $this->_sections['i']['index'] += $this->_sections['i']['step'], $this->_sections['i']['iteration']++):
$this->_sections['i']['rownum'] = $this->_sections['i']['iteration'];
$this->_sections['i']['index_prev'] = $this->_sections['i']['index'] - $this->_sections['i']['step'];
$this->_sections['i']['index_next'] = $this->_sections['i']['index'] + $this->_sections['i']['step'];
$this->_sections['i']['first']      = ($this->_sections['i']['iteration'] == 1);
$this->_sections['i']['last']       = ($this->_sections['i']['iteration'] == $this->_sections['i']['total']);
?>
			<?php $this->assign('selected_c', ""); ?>
			<?php if (( $this->_tpl_vars['categories_list']->mCategorySelected == $this->_tpl_vars['categories_list']->mCategories[$this->_sections['i']['index']]['id'] )): ?>
				<?php $this->assign('selected_c', "class=\"selected\""); ?>
			<?php endif; ?>
			<li><a <?php echo $this->_tpl_vars['selected_c']; ?>
 href="<?php echo ((is_array($_tmp=$this->_tpl_vars['categories_list']->mCategories[$this->_sections['i']['index']]['link'])) ? $this->_run_mod_handler('prepare_link', true, $_tmp, 'http') : smarty_modifier_prepare_link($_tmp, 'http')); ?>
">&raquo; <?php echo $this->_tpl_vars['categories_list']->mCategories[$this->_sections['i']['index']]['name']; ?>
</a></li>
		<?php endfor; endif; ?>
	</ol>
</div>